Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab1HQLoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:44:44 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35750 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1HQLom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:44:42 -0400
Subject: Re: Boot kernel panic after upgrade 3.0.1 -> 3.0.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Torquil Macdonald =?ISO-8859-1?Q?S=F8rensen?= <torquil@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E4B9903.4000203@gmail.com>
References: <4E4B9903.4000203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 13:44:38 +0200
Message-ID: <1313581478.24749.25.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 12:33 +0200, Torquil Macdonald Sørensen wrote:
> At boot time, I get the following message on screen (copied by hand, but I'm 
> hoping there are not too many mistakes...):
> 
> Kernel panic, not syncing: VFS Unable to mount root fs on unknown block(0,0)
> Pid: 1. comm: swapper  Not tainted 3.0.2 #1
> Call Trace:
>   [<fffffff8127e4a9>] ? panic 0xa4 0x19b
>   [<fffffff813f1e56>] ? mount_block_root+0x236/0x254
>   [<fffffff81002930>] ? do_bounds+0x57/0x65
>   [<fffffff813f1ff6>] ? prepare_namespace+0x133/0x169
>   [<fffffff813f1b7c>] ? kernel_init+0x105/0x10a
>   [<fffffff81284a94>] ? kernel_thread_helper+0x4/0x10
>   [<fffffff813f1a77>] ? start_kernel+0x341/341
>   [<fffffff81284a90>] ? gs_change+0xb/0xb

I tend to see messages like that when I've messed up some basic setting
needed to boot a kernel. 

My first suggestion would be to check your kernel command line. Does it
have a "root=" parameter? Another thing I'd check is the initramfs. Does
the bootloader pass the kernel an initramfs? Is the initramfs a valid
initramfs? Does the (valid) initramfs have the stuff the kernel needs
(block modules, fs modules). Stuff like that ...


Paul Bolle

