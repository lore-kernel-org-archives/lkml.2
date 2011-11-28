Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1K1SOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:14:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44789 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1K1SOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:14:42 -0500
MIME-Version: 1.0
Date: Mon, 28 Nov 2011 12:14:41 -0600
Message-ID: <CAHxD=PC-rvD_zBmp-VHvxNCe_sgXDGHDYwajdn_ukAFqK0eDOg@mail.gmail.com>
Subject: Kernel oops on bootup if initramfs built with udev version higher
 than 163
From: Jack Byer <ftn768@gmail.com>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My computer hangs on bootup if I build my initramfs with a version of
udev higher than 163. I've obtained a boot log by using the serial
console and uploaded the results here:

Successful boot: http://pastebin.com/UUEHqjge
Failed boot: http://pastebin.com/ZEp1ni3Z

The only difference between the two cases is the version of udev used
to build the initramfs - both kernel images are the same. If I boot an
initramfs that uses an old version of udev but then have a newer
version installed in the OS it does not cause any problems.

I've been working around this problem for a long time first by
temporarily downgrading udev each time I needed to build a new
initramfs and later by building kernel images that didn't need modules
to boot so that I could keep using the same initramfs across kernel
upgrades. Now that I have a working serial console to capture the boot
sequence I'd like to see if there's any information I can provide that
would enable the problem to be fixed the right way.
