Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2GZXrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 19:47:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46343 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GZXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 19:47:53 -0400
Date: Thu, 26 Jul 2012 16:47:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 00/11] VMCI for Linux
Message-ID: <20120726234749.GA3849@kroah.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:39:29PM -0700, Andrew Stiegmann (stieg) wrote:
> In an effort to improve the out-of-the-box experience with Linux
> kernels for VMware users, VMware is working on readying the Virtual
> Machine Communication Interface (vmw_vmci) and VMCI Sockets
> (vmw_vsock) kernel modules for inclusion in the Linux kernel. The
> purpose of this post is to acquire feedback on the vmw_vmci kernel
> module. The vmw_vsock kernel module will be presented in a later post.

Ugh, you do realize this is the middle of the merge window when we are
all busy doing other things than code review of new stuff, right?  It's
going to be a few weeks before I can look at this, sorry.

good luck,

greg k-h
