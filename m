Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423110Ab2CPQBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:01:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40348 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032916Ab2CPQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:01:51 -0400
Date: Fri, 16 Mar 2012 09:01:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120316160147.GC975@kroah.com>
References: <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
 <20120315113115.GA32149@aftab>
 <4F61E35B.9000906@redhat.com>
 <20120315213844.GA3781@aftab>
 <4F62FE38.6060704@redhat.com>
 <20120316153001.GH28696@kroah.com>
 <4F635FC1.40606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F635FC1.40606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:44:01PM -0300, Mauro Carvalho Chehab wrote:
> Em 16-03-2012 12:30, Greg KH escreveu:
> > On Fri, Mar 16, 2012 at 05:47:52AM -0300, Mauro Carvalho Chehab wrote:
> >> 2) per Greg's request, we should not use struct sysdev, using instead,
> >>    struct device. That means that everything under
> >> 	/sys/devices/system/edac/mc/
> >>    will move to another place, likely:
> >> 	/sys/devices/ras/
> > 
> > No, you can keep things under /sys/devices/system/edac/ if you use a
> > struct device, no need to move things and break userspace tools if you
> > don't have to.
> 
> Hmm... How?

Just point your parent of your device to the same place.  Converting
from using 'struct sysdev' is easy, as the conversion is already done
in-tree to real 'struct device' so there shouldn't be any problems.

Or am I missing something here?

thanks,

greg k-h
