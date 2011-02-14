Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1BNRK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:10:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1BNRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=fHnNQ3o2Sk9v2ZLQ5fF1NzSunacZlj7IjbzyaLs190qXvAaVd0VSgHe75fcml3eLE9
         xpEcoa2AcvFwFF/Iu364rGAFZhbUHlK41J+IvnEaDNeQr2ofgMQn3jCDYQwI/J/kTkd0
         5kWv8zINy+FAGYgGGklwxu5HLoHDYSh9K3yy8=
MIME-Version: 1.0
In-Reply-To: <20110210223300.376194902@linutronix.de>
References: <20110210222908.661199947@linutronix.de> <20110210223300.376194902@linutronix.de>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 14 Feb 2011 22:37:16 +0530
X-Google-Sender-Auth: t82BrIHLTTetHsUu3QcdQetEZeo
Message-ID: <AANLkTin8giwcc-odm29v5hu4fe-yH1Ub1wtJZ8sx93Vf@mail.gmail.com>
Subject: Re: [patch 63/75] genirq: Add IRQCHIP_SET_TYPE_MASKED flag and IRQD_WAKE_SET
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 05:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> Add also a flag which reflects the WAKEUP state of the interrupt line,
> which is also required by some of those chips.

This part (the IRQD_WAKE_SET mentioned in the subject) appears to be
missing from this patch?
