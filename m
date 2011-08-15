Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1HOGQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:16:31 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62230 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1HOGQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAAmnkz=2zDa2TTHduUvkwXA7X3ojYqQ+kRPPAwanOUu38YDrjg@mail.gmail.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.iJB.HOCSOB@chimera>
	<CAOJsxLEF6sSibtTGa+un_4eDLHMniFyAkSOUtHYpmFtPTbEKiA@mail.gmail.com>
	<CAAmnkz=2zDa2TTHduUvkwXA7X3ojYqQ+kRPPAwanOUu38YDrjg@mail.gmail.com>
Date: Mon, 15 Aug 2011 09:16:27 +0300
X-Google-Sender-Auth: wd6SS8Q4g-iXi8-JFJzB_8SO9H4
Message-ID: <CAOJsxLEuwUNhOqGUg=3oKt-HOWFRo2Ewe47YhH0NnLeuDUjsHQ@mail.gmail.com>
Subject: Re: [Bug #38612] Boot time warnings in APIC
From: Pekka Enberg <penberg@kernel.org>
To: "Bill Huey (hui)" <bill.huey@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 9:14 AM, Bill Huey (hui) <bill.huey@gmail.com> wrote:
> The crash itself was pretty random and the machine was half crippled.
> That's the best I can do in that circumstance.

How did you capture the oops? Did you try netconsole? There's
documentation of it in Documentation/networking/netconsole.txt and
this article explains how to set it up:

http://mindplusplus.wordpress.com/2010/03/06/using-netconsole-on-linux/
