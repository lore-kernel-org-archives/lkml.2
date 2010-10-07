Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab0JGKQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 06:16:34 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:46898 "EHLO
	mail2.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351Ab0JGKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 06:16:33 -0400
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 06:16:33 EDT
Message-ID: <4CAD96E3.3010106@mimc.co.uk>
Date: Thu, 07 Oct 2010 10:46:11 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: kernel@avr32linux.org
Subject: Help needed diagnosing kernel error message
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are running 2.6.31 on a custom embedded board (based on the AVR32 chip).

It has flash, sdram and fram all connected via an external bus.

We have found that under heavy external bus load, the target appears to lockup (i.e. network
timeouts, ssh sessions dropped, userspace tasks halt, etc).

Having inspected the board out with an oscilloscope, I can see that the sdram bus is still active
doing tight read / write cycles.

As part of the diagnosis, I have checked /var/log/messages, and found the following entries which
I've never seen before:-

Oct  6 19:21:06 mimc200 lpr.err kernel: hars
Oct  6 19:24:57 mimc200 lpr.err kernel: hars
Oct  6 19:26:54 mimc200 lpr.err kernel: hars
Oct  6 19:27:14 mimc200 lpr.err kernel: hars
Oct  6 19:27:55 mimc200 lpr.err kernel: hars
Oct  6 19:27:58 mimc200 lpr.err kernel: hars
Oct  6 19:28:09 mimc200 lpr.err kernel: hars
Oct  6 19:28:39 mimc200 lpr.err kernel: hars
Oct  6 19:29:08 mimc200 lpr.err kernel: hars
Oct  6 19:29:11 mimc200 lpr.err kernel: hars

Can anyone shed light on which might be causing these ?

What extra info can I supply to assist the ml in helping me ?

Regards
Mark
