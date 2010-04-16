Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0DPIhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:37:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0DPIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:37:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: sched_clock - microblaze
Date: Fri, 16 Apr 2010 10:37:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: wuzhangjin@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <4BC728DD.5020404@petalogix.com> <201004152152.03883.arnd@arndb.de> <4BC8024E.6020006@petalogix.com>
In-Reply-To: <4BC8024E.6020006@petalogix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004161037.26070.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/wv4rD1HTW8XhvAhWiccxxWcXhxiNWDyWI/d4
 FZS+Xvb7jg/0Dd37SOx8ukYQZsF/pqA2Kyc2Z/TdnMYUrcgEd0
 XYV1qrsCqTJHzDLg4MpfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 April 2010, Michal Simek wrote:
> Why is sched_clock called in init_idle? Do you get any non zero value on 
> any ARCH?

Yes, some architectures return a real-time value here that starts before boot.
Also, when the clock starts at boot time, there can be a significant time
spent in the firmware and early kernel code before we get to init_idle.

	Arnd
