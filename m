Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab1KGOo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:44:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43345 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1KGOo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:44:28 -0500
MIME-Version: 1.0
X-Originating-IP: [72.21.198.64]
Date: Mon, 7 Nov 2011 09:44:27 -0500
Message-ID: <CAO9zADy0MSVtMVaKTBAnn7-QmHTrcW2abgBKTRcvdJme-HjjAg@mail.gmail.com>
Subject: Kernel version not updated on http://www.kernel.org/kdist/finger_banner
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently I see http://www.kernel.org/ now shows 3.1 as the latest
mainline kernel version (it was 3.1-rcX) a few days ago if I recall
even though 3.1 was released last month.
However, as stated on the homepage, for those who use this in scripts
and such, the latest version is still 3.1-rc4:

Aug 21, 2003: Please don't use finger.kernel.org for any sort of
automatic monitoring. The number of automatic bots hitting this port
is causing the finger daemon to shut down more often than not. The
same information is available from
http://www.kernel.org/kdist/finger_banner.

http://www.kernel.org/kdist/finger_banner shows:
The latest linux-next version of the Linux kernel is:         next-20110831
The latest linux-next version of the Linux kernel is:         next-20110831
The latest snapshot 3 version of the Linux kernel is:         3.1-rc4-git2
The latest mainline 3 version of the Linux kernel is:         3.1-rc4
The latest stable 3.0 version of the Linux kernel is:         3.0.4
The latest stable 2.6.39 version of the Linux kernel is:      2.6.39.4
The latest stable 2.6.38 version of the Linux kernel is:      2.6.38.8
The latest stable 2.6.37 version of the Linux kernel is:      2.6.37.6
The latest longterm 2.6.35 version of the Linux kernel is:    2.6.35.14
The latest longterm 2.6.34 version of the Linux kernel is:    2.6.34.10
The latest longterm 2.6.33 version of the Linux kernel is:    2.6.33.19
The latest longterm 2.6.32 version of the Linux kernel is:    2.6.32.46
The latest longterm 2.6.27 version of the Linux kernel is:    2.6.27.59

Should one use the homepage / finger_banner or write a script to
monitor the FTP directory to check for the latest version/s?

Justin.
