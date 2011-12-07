Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1LGWmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:42:46 -0500
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:32924 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757080Ab1LGWmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:42:45 -0500
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Sander & Lighting
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: reboot fails on preempt rt 3.0.12-rt29
Date: Wed, 7 Dec 2011 23:42:33 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc3; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112072342.33752.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.12.7.223019
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

As you might now i am running a slightly patched rt 3.0.12-rt29 on arm pcm43 
platform. Strangely the upstart 1.3 reboot command gives me very seldom the 
error: 
"reboot: Unable to execute shutdown: Bad address"

Since the string "Bad address" is nowhere to find within the upstart or libnih 
sources i guess it is coming from the kernel sources or perror?

Reboot in turn calls shutdown -r via execv. When calling reboot another time 
it just works... The error seems so seldom that it didn't occur to me two 
times in a row for now.

Best regards
Tim

