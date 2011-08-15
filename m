Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1HOGMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:12:17 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:55444 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1HOGMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <bkwpSnItbJM.A.iJB.HOCSOB@chimera>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.iJB.HOCSOB@chimera>
Date: Mon, 15 Aug 2011 09:12:12 +0300
X-Google-Sender-Auth: TR-mryqczWwZ9q7p0_dWznoTNmM
Message-ID: <CAOJsxLEF6sSibtTGa+un_4eDLHMniFyAkSOUtHYpmFtPTbEKiA@mail.gmail.com>
Subject: Re: [Bug #38612] Boot time warnings in APIC
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Bill Huey <bill.huey@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 10:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38612
> Subject         : Boot time warnings in APIC
> Submitter       : Bill Huey <bill.huey@gmail.com>
> Date            : 2011-07-01 06:44 (45 days old)

Even if you suspect hardware problems, it's best to CC maintainers.
It's unfortunate that you didn't include full dmesg because there
might have been more clues on what's going on.
