Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1B1WAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 17:00:06 -0500
Received: from legolas.restena.lu ([158.64.1.34]:43847 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1B1WAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 17:00:05 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 17:00:04 EST
Date: Mon, 28 Feb 2011 22:50:03 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc6: SysRq broken?
Message-ID: <20110228225003.2cb4f62d@neptune.home>
In-Reply-To: <20110228214054.GA18538@p183.telecom.by>
References: <20110228214054.GA18538@p183.telecom.by>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 February 2011 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> It just strikes me that SysRq is broken here:
> Alt+SysRq+h doesn't print anything
> 
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_INPUT_EVDEV=y
> kernel.sysrq=1
> echo h >/proc/sysrq-trigger works
> 
> Keyboard is USB one, "Logitech HID compliant keyboard".

I've seen same kind of issue with built-in keybaord (PS2) of my laptop.

Sysrq-Sync, Sysrq-Umount, Sysrq-Help didn't work but Sysrq-reBoot did.

In my case it was during "stuck" shutdown process, caps key was still
working and toggled caps LED anything else didn't trigger anything visible.

Bruno
