Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0EER3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:29:45 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:29887 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab0EER3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:29:43 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: pv-drivers@vmware.com
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Date: Wed, 5 May 2010 10:29:40 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
       Pankaj Thakkar <pthakkar@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20100504230225.GP8323@vmware.com> <20100505172316.GA25338@infradead.org>
In-Reply-To: <20100505172316.GA25338@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051029.42052.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010 10:23:16 am Christoph Hellwig wrote:
> On Tue, May 04, 2010 at 04:02:25PM -0700, Pankaj Thakkar wrote:
> > The plugin image is provided by the IHVs along with the PF driver and is
> > packaged in the hypervisor. The plugin image is OS agnostic and can be
> > loaded either into a Linux VM or a Windows VM. The plugin is written
> > against the Shell API interface which the shell is responsible for
> > implementing. The API
> 
> We're not going to add any kind of loader for binry blobs into kernel
> space, sorry.  Don't even bother wasting your time on this.
> 

It would not be a binary blob but software properly released under GPL.
The current plan is for the shell to enforce GPL requirement on the
plugin code, similar to what module loaded does for regular kernel
modules.

-- 
Dmitry
