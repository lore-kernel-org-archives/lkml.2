Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1KUTD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:03:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63044 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1KUTDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:03:55 -0500
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 20:03:55 +0100
Message-ID: <CAEPe-G+MrLWHgugZhvDXrPL8DW+BSsDJ8SrPaT=tbeopUBn6DA@mail.gmail.com>
Subject: [Bugreport] Screen backllight issues on FirePro M5950 (HP EliteBook 8560w)
From: Artur Flinta <aflinta@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: alexander.deucher@amd.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have HP Elitebook 8560w with FirePro M5950, Fedora 16, kernel 3.1.1,
xorg ati driver 6.14.3 and issues with screen backlight - can't dim
it.I can write to /sys/class/backlight/acpi_video0/brightness values
from 0 to 20 (as stated in max_brightness), but it have no effect on
the screen, values in brightness as well as in actual_brightness
reflects written number.
Before system boot, I can change brightness of the screen, and it
persist in operating system. Value of the
/sys/class/backlight/acpi_video0/brightness indicates maximum
brightness (20) even if minimal was set before boot. It seems that
built in kernel radeon driver does not correctly handle backlight on
this hardware.

Regards
Artur
-- 
Każdy problem ma swoje rozwiązanie, zatem
jeżeli nie ma rozwiązania to nie ma problemu.
