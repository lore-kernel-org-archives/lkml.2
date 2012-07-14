Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2GNOOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 10:14:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56370 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2GNOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:14:17 -0400
Date: Sat, 14 Jul 2012 15:14:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714141415.GD31729@ZenIV.linux.org.uk>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
 <20120714134849.GA1175@localhost>
 <20120714135849.GA1257@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714135849.GA1257@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 09:58:49PM +0800, Fengguang Wu wrote:
> > Hi Al, here I got the output for
> > 
> > (qemu) sendkey alt-sysrq-l
> > (qemu) sendkey alt-sysrq-t
> 
> I repeated that several times and here are the results.
> 
> (qemu) sendkey alt-sysrq-l
> (qemu) sendkey alt-sysrq-l
> (qemu) sendkey alt-sysrq-l
> (qemu) sendkey alt-sysrq-t
> (qemu) sendkey alt-sysrq-t
> (qemu) quit
> 
> The user space shutdown is polling on something, which prevents the
> system from reboot..

Which userland it is?
