Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3AEKvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 05:51:01 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:37048 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3AEKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 05:50:59 -0500
Message-ID: <50E8058F.6060104@gmail.com>
Date: Sat, 05 Jan 2013 11:50:55 +0100
From: Arend van Spriel <aspriel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
CC: dri-devel@lists.freedesktop.org, dev@lists.compiz.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: 3.8-rc1: nouveau: X window session not starting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if it is a kernel issue or user-space. Truth is probably
somewhere in the middle. It popped up moving to 3.8-rc1 using nouveau.
Using nvidia's driver works fine. With nouveau, after entering login
credentials in lightDM the user session does not start and I am back at
the lightDM login screen. This is shown in the syslog:

Jan  5 11:28:34 linux-e6410-1 rtkit-daemon[1888]: Successfully made
thread 4920 of process 4920 (n/a) owned by '110' high priority at nice
level -11.
Jan  5 11:28:34 linux-e6410-1 rtkit-daemon[1888]: Supervising 9 threads
of 3 processes of 2 users.
Jan  5 11:28:34 linux-e6410-1 pulseaudio[4920]: [pulseaudio] pid.c:
Daemon already running.
Jan  5 11:28:53 linux-e6410-1 pulseaudio[2767]: [pulseaudio] x11wrap.c:
XOpenDisplay() failed
Jan  5 11:28:53 linux-e6410-1 pulseaudio[2767]: [pulseaudio] module.c:
Failed to load module "module-x11-publish" (argument: "display=:0"):
initialization failed.
Jan  5 11:28:54 linux-e6410-1 kernel: [ 2454.499025] nouveau E[    4780]
failed to idle channel 0xcccc0000

I can start sessions for Xfce and 'Gnome Classic (without Effects)' so I
suspect compiz to fail. Did not try xcompmgr.

Gr. AvS
