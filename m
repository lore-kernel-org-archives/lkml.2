Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1H2Tx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:53:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54955 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1H2Tx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:53:28 -0400
MIME-Version: 1.0
Date: Mon, 29 Aug 2011 23:53:27 +0400
Message-ID: <CAKMM7E3E7z_EXgaFLD3iwo-L9W2YhB4FQsWeyDeaGR7L5Oe-XA@mail.gmail.com>
Subject: Linux kernel ARM problem
From: =?KOI8-R?B?4s/Hz83B2s/XIOvJ0snMzA==?= <nnovnet@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day!
I hope very much for your help. I have been porting Android on HTC
device Mega (Qualcomm

MSM7225 ) with loader Haret. At that moment I'm using to debug the
code vibratory phone and I

can say that Haret work.For the kernel I used source code from a
similar device HTC Buzz with

some modifications.I am sure that the kernel is loaded into RAM so I
added vibration code to the

kernel/head.S and receive device vibrating. However, when I added the
code in the vibration board-

buzz.c  that does not work anyway.My device freeze after message
"Booting Linux". Tell me how I can track and debug the error? There
especially

in the kernel boots Buzz? That may interfere with loading on an
identical device?Thank you in

advance for your help.
