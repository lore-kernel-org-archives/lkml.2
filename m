Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498Ab2CNWk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:40:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34403 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2CNWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:40:54 -0400
Date: Wed, 14 Mar 2012 15:40:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120314224050.GA32297@kroah.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314223102.GA27602@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:31:02PM +0100, Borislav Petkov wrote:
> On Wed, Mar 14, 2012 at 01:43:55PM -0700, Greg KH wrote:
> > > He thinks that a multi-layer struct should be created inside that directory
> > > (it could have 2 or 3 levels of directories, depending on how the memory is
> > > organized at the memory controller), instead of having a large number of files
> > > there.
> > 
> > Why create subdirs?  If those subdirectories are not real devices,
> > showing a real hierarchy, then do not create them as userspace will get
> > very confused very quickly.
> 
> Why, IMO, we agreed on the following layout
> 
> rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> |-- CE
> |-- UE
> `-- dimm_size
> 
> with CE being the correctable errors counter and UE be optional and only
> present when it makes sense for the hardware.
> 
> This is not multi-layered, it is very easy to implement and mirrors all
> possible memory controllers from the point of view of the single DIMM.
> no? Or am I missing something...?

Looks fine to me, assuming "rankX" is the dimm itself?

greg k-h
