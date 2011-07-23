Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1GWKUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:20:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:37189 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GWKUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:20:11 -0400
Date: Sat, 23 Jul 2011 12:20:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rolando Martins <rolando.martins@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Dhaval Giani <dhaval_giani@gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <CABcS5h2EMMsKPw7DcQ9XdUKamOe3m4CN1A3hwRyPkfpAMO4Orw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1107231202050.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <CABcS5h01jpOSKcKtrJ65AqNNQDCAOutQADAE_pcRp-MPBoO-VA@mail.gmail.com> <alpine.LFD.2.02.1107230930330.2702@ionos> <CABcS5h2EMMsKPw7DcQ9XdUKamOe3m4CN1A3hwRyPkfpAMO4Orw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Rolando Martins wrote:
> Hi Thomas,
> 
> Do you see it being fixed in a near future?

Delegating that question to scheduler wizards and folks you created
that mess in the first place.
