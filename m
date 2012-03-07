Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2CGFgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:36:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36354 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751029Ab2CGFgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:36:31 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX199TRQEIN99Lfd3gOpBAnTqDQPn//LE8rSO2exu0F
	09SOS8tyIUJFFl
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
References: <20120228010511.GA8453@kroah.com>
	<20120228010434.412979550@linuxfoundation.org>
	<87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
	<CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
	<alpine.LFD.2.02.1203060927190.2742@ionos>
	<alpine.LFD.2.02.1203060957140.2742@ionos>
	<alpine.LFD.2.02.1203062019340.2742@ionos>
	<8762eh1p7d.fsf@turtle.gmx.de>
	<alpine.LFD.2.02.1203062101040.2742@ionos>
	<CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
	<alpine.LFD.2.02.1203062243130.2742@ionos>
	<CA+55aFwTYRO-qOPvSPkEf_5=10EOTBQa+DpRHFf_=iwXOFi4xw@mail.gmail.com>
Date: Wed, 07 Mar 2012 06:36:24 +0100
In-Reply-To: <CA+55aFwTYRO-qOPvSPkEf_5=10EOTBQa+DpRHFf_=iwXOFi4xw@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 6 Mar 2012 14:33:54 -0800")
Message-ID: <87lindnfaf.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-06 23:33 +0100, Linus Torvalds wrote:

> On Tue, Mar 6, 2012 at 2:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set
>
> Ok, can we get this fixed version tested too by people who saw the problem?

It works for me.

Cheers,
       Sven 
