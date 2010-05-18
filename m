Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0ERNU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:20:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36858 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0ERNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=F9VpCuI8g06aEh4SrkzmjDywnAdUZkoDNalyDWLHP/aqPzJ7RwnJzbEvUWgwGA/ET7
         ulMmHtfc/PPvEuS9R7b4pL0FjADjBLh+HDpzRZWXkOxk/HprqQBUc3q1kFRE6AERDVKH
         No8AmD2kWfSUaHLMb51dLIle7BXRjiZnO1Tf8=
MIME-Version: 1.0
Date: Tue, 18 May 2010 08:13:33 -0500
Message-ID: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com>
Subject: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after 
	console_init
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to have printk output to my ttyS0 console all the time,
with 2.6.33-rt17, after kernel is booted up with all messages shown
normally on the serial port until I login in, from this point on, all
printk messages go to 'dmesg(log_buf)' fine, but I could never get
them shown up on serial console anymore. I tried adjust
/proc/sys/kernel/printk etc none helped.

Switch PREEMPT_RT to PREEMPT_VOLUNTARY and reboot, now everything
works, i.e. I can see printk on my console after I login.

Look at the RT patch itself, I do find some changes to printk itself,
however I'm unsure what is causing this(i.e printk not going to
console after login).

Thanks,
Xianghua
