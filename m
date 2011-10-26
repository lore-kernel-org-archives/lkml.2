Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab1JZRS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:18:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40374 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab1JZRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:18:25 -0400
MIME-Version: 1.0
Date: Wed, 26 Oct 2011 19:18:24 +0200
Message-ID: <CANQUKa2UHBPad2m2EZb0vH0jOOTNU7vHqzuUTTi0vt5AuTpdzA@mail.gmail.com>
Subject: vga_switcheroo causes system freeze
From: Wim Goeman <wimgoeman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working with a new HP PC (dv7) which supports Hybrid Graphics in
terms of the intel graphics and radeon graphics (as can bee found in
lspci).

Currently I am only working with the Intel integrated graphics, and
both adapters are powered on.

My goal was to deactivate the intel graphics and activate the radeon
graphics, as the machine is plugged in to the power supply most of the
time. To achieve this I tried the following:

cat /sys/kernel/debug/vga_switcheroo/switch
--> shows both cards are powered on and IGD is in use (the intel card)

echo DIS > /sys/kernel/debug/vga_switcheroo/switch
--> gives an error message because X is still running

I kill the X session
echo DIS > /sys/kernel/debug/vga_switcheroo/switch
--> The system freezes completely. No warning or error, no blinking
cursor, nothing. I have to power off using the power button.

Does anyone have a suggestion on what I can try to fix this?

I am posting on the mailing list because the bug tracker seems to be
down since a few days now.

For more details, please see launchpad bug #881132

Thanks in advance for having a look at this,

Wim
