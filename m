Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1KNTbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:31:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64002 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1KNTbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:31:13 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Natanji <natanji@gmail.com>
Subject: Re: Regression in thinkpad-acpi events
Date: Mon, 14 Nov 2011 20:31:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4EBAC3B5.5060405@gmail.com>
In-Reply-To: <4EBAC3B5.5060405@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111142031.06663.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 9 listopada 2011 o 19:17:25 Natanji wrote:
> Hello everyone,
> first time posting on this last, and I'm not subscribed, so please CC
> any replies to me. ;)
> 
> I'm running Kernel version 3.1-4 using Arch Linux (32 Bit) on a Thinkpad
> X60 Tablet. Since upgrading from a pre-3.1 kernel to a post-3.1 kernel,
> the Thinkpad-specific ACPI events (from thinkpad-acpi) are completely gone.
> 
> This can be observed by using the acpi_listen command. For instance, no
> ACPI events happen when swiveling the display, and the sleep button returns
> 	button/sleep SBTN 00000080 00000000
> instead of the previous
> 	ibm/hotkey HKEY 00000080 00001004
> 
> The bug was reported in the Arch Linux bugtracker [1] and it was
> suggested to report this upstream, so this is what I did now. Sadly I
> have no idea how I could find out if this is indeed a kernel bug or not;
> I have never compiled my own kernel so what I can give you is probably
> limited. But I suppose quite a few members of this list use a Thinkpad.
> If there is anything else I can help out with, just tell me.
> 
> [1] https://bugs.archlinux.org/index.php?do=details&task_id=26658

Can you check that 3.1 works or not? Or try bisection that it is regression 
after 3.0 or 3.1 kernel.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
