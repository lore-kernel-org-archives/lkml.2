Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2C1AUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:20:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36914 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2C1AUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:20:45 -0400
MIME-Version: 1.0
Date: Tue, 27 Mar 2012 17:20:43 -0700
Message-ID: <CAN4-gUF33wb=4Ry7em_-4Hp-OTWDmnSJjzJmE_0c-J4S_mhU2A@mail.gmail.com>
Subject: Support for Perle SXPCI Universal Serial Cards
From: "Paul G. Allen" <pgallen@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a production system that currently runs on Windows XP. The
system is Java code and was originally designed to run on Linux with a
different multi-IO interface from Digi. The system connects to up to
16 serial devices and is used to load firmware and configure the
devices on a production line. Currently a Perle SXPCI Universal Serial
card is used to support up to 32 serial ports per machine. Because at
the time of purchase CentOS 5.1 did not have a Perle driver included,
nor did Perle support the 2.6.x kernel used in that release, I was
forced to switch to Windows XP, which caused numerous other Windows
related issues such as much slower Java performance, Windows update
issues, Windows serial port errors, etc. (problems that have never
been seen in Linux using the same Java code.)

Can anyone tell me if this card is currently supported in a recent
Linux kernel (the last kernel I have seen support in is 2.6.9), or if
there is a patch or driver available for it? I have had poor serial
support performance on Windows with any serial device, and this
includes Windows 7 with USB->Serial devices, native serial devices,
multi-IO cards, etc. Because XP has reached EOL, I am forced either
deal with Windows 7, or upgrade to Linux, even if it means porting the
older Perle code to a newer kernel.

Thanks in advance,

PGA
-- 
Paul G. Allen, BSIT/SE
Owner, Sr. Engineer
Random Logic Consulting
www.randomlogic.com
