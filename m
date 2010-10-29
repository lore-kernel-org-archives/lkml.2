Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab0J2MMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:12:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38394 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761374Ab0J2MME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wxdXoRDhhf5hd1dikgVVaOeOca53D0SZ1SvZVdOYmT9l8ychggarRTfideu6GZ/Lvl
         0qUKHL2uPITN6EbJZmGKQg8LM12YdaKumdrNuFh7VvYjPCPv4bkgoBjHr7vOETSGqOMV
         2tvuXrN22DQWx5DGwJ7w7E6NrBQe2Ih1YApTA=
MIME-Version: 1.0
Date: Fri, 29 Oct 2010 15:12:02 +0300
Message-ID: <AANLkTik8__Q9au8u3fxsRr3cNdpjXZqmra9ohKTpSR+k@mail.gmail.com>
Subject: Webcam driver not working: drivers/media/video/gspca/ov519.c device 05a9:4519
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, moinejf@free.fr, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, sorry for the noise, but in current mainline (2.6.36-git12)
there are some updates in ov519.c
I'm running this kernel now and my camera is still not working (tested
in windows and it works).

lsusb:
Bus 008 Device 002: ID 05a9:4519 OmniVision Technologies, Inc. Webcam Classic

But on the case it writes: GRANDTEC Grand IP CAMERA PRO Model: 2
In have an LAN or USB switch mode.

Picture: http://tinypic.com/r/292llcg/7

Chips:
0705C07353 label on W9812G2GH-6 chip

MX chip:
T073520
29LV160CBTC-70G
2W417500

IC+ chip:
IP101A LF
0731S15
FNS1877.1

The errors I get:
Camorama Webcam Viewer: Could not connect to video device (/dev/video0).
Please check connection.

Cheese Webcam Booth: No device found.
