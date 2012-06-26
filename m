Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2FZBws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:52:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40907 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:52:47 -0400
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 21:52:46 -0400
Message-ID: <CAH0O0Mx+-QY9Wx4wZpO2vZNViV0UWAEns7AwBXwEh96brCzuug@mail.gmail.com>
Subject: Kernel not detecting all of physical RAM in 1st generation Apple TV
From: Bharath Ramesh <bramesh.dev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to get a minimal kernel config running on a 1st generation
Apple TV to compile the kernel so that I can have it detect all of the
256MB of RAM the device has. A brief summary to get Linux booting on
the 1st generation Apple TV requires the use of the atv-bootloader
project [1]. The 1st generation Apple TV uses EFI and the
atv-bootloader project translates EFI structures to standard PC BIOS
structures. The issue I am facing is that kernel doesnt always detect
the entire 256MB of RAM that the Apple TV has. With a very minimal
change in the kernel config I can cause the kernel not to detect the
entire 256MB of RAM. I have test config along with the respective
dmesg output which shows this issue. This was not the case with the
earlier 2.6.24 kernel that I am running, the 2.6.24 kernel is a Ubuntu
8.04 distribution kernel. The following config and dmesg is using
kernel.org source.

config-3.2.18-nouveau-256M: http://pastebin.com/9V8dSED3
config-3.2.18-nouveau-64M: http://pastebin.com/CsUK0yy3
config.3.2.18-nouveau-256M-64M.diff: http://pastebin.com/MkYbQf5V
dmesg.3.2.18-nouveau-256M: http://pastebin.com/UUYBzqm8
dmesg.3.2.18-nouveau-64M: http://pastebin.com/FDntUsfd
dmesg.3.2.18-nouveau-256M-64M.diff: http://pastebin.com/2myAa9Z0

Any help in debugging this issue that I can get the kernel to always
detect all of the RAM would be greatly appreciated. I am not
subscribed to the list, would greatly appreciate it if I am copied in
the response.

Thanks,

Bharath

[1] http://code.google.com/p/atv-bootloader/
