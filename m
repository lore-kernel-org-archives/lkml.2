Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1EDOm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:42:59 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25214 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754362Ab1EDOm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:42:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: TBwwBIYVM1kNwgPsfHlzQ3hLXgc_kM5J973JHM9bWNXgHaO
 Mict2stBPICafowYAC8Ga0XhKTnvT.yUwT7yVOPhZscSIQ0TC9Y9zLCs9cuA
 PNT7tzGOLrUMsGbK0HP2rnc1CujoWYNPQt4oQsot5_zz4i.kge4dcvdpIWOu
 S7KHkXOpoFq8qhbsXgcxRysGIJybBRFOy9kUtiDaMlXjJrjNw.F5nulNHnN5
 deg8ha7oTZ42YT7jNgwy6Vvwxk4Mu2e4z833ID.CMzQ432h78XbgtanVoC4b
 GX7P43.wDrvQ9CaA7hUutTDlz.zbKB3ZC5ZAenDh4LbCI3V69Xqx7GNyhtzC
 g25nRibJzgPFceli3LrGjQg--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 09:42:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Fix the lockless code on 32-bit platforms with no
 64-bit cmpxchg
In-Reply-To: <20110504143616.GA19986@elte.hu>
Message-ID: <alpine.DEB.2.00.1105040942190.5495@router.home>
References: <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504141413.GA14127@elte.hu> <20110504143616.GA19986@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Ingo Molnar wrote:

> Ok, the patch below is looking really good - the test would have crashed on the
> bad kernel. I think we can consider the regression fixed:
>
>   Acked-and-tested-by: Ingo Molnar <mingo@elte.hu>
>
> I'll keep it running some more to make really sure it's fixed, plus it would be
> nice if Walter tested your fix as well.

Looks good and is exactly what I have here.

Acked-by: Christoph Lameter <cl@linux.com>
