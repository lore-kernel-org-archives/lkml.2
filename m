Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1KISR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:17:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45472 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1KISR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:17:28 -0500
Message-ID: <4EBAC3B5.5060405@gmail.com>
Date: Wed, 09 Nov 2011 19:17:25 +0100
From: Natanji <natanji@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regression in thinkpad-acpi events
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
first time posting on this last, and I'm not subscribed, so please CC
any replies to me. ;)

I'm running Kernel version 3.1-4 using Arch Linux (32 Bit) on a Thinkpad
X60 Tablet. Since upgrading from a pre-3.1 kernel to a post-3.1 kernel,
the Thinkpad-specific ACPI events (from thinkpad-acpi) are completely gone.

This can be observed by using the acpi_listen command. For instance, no
ACPI events happen when swiveling the display, and the sleep button returns
	button/sleep SBTN 00000080 00000000
instead of the previous
	ibm/hotkey HKEY 00000080 00001004

The bug was reported in the Arch Linux bugtracker [1] and it was
suggested to report this upstream, so this is what I did now. Sadly I
have no idea how I could find out if this is indeed a kernel bug or not;
I have never compiled my own kernel so what I can give you is probably
limited. But I suppose quite a few members of this list use a Thinkpad.
If there is anything else I can help out with, just tell me.

[1] https://bugs.archlinux.org/index.php?do=details&task_id=26658
