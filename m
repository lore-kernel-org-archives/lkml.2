Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2CFXiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:38:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57104 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759329Ab2CFXis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:38:48 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+1z4l0HbS1f76VBnXUxZTZZgSYlVyzaG349d+NUX
	7LVliHo/u+BF/d
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
Date: Wed, 7 Mar 2012 00:38:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.2-9.slh.2-aptosid-686; KDE/4.6.5; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Sven Joachim <svenjoac@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
References: <20120228010511.GA8453@kroah.com> <alpine.LFD.2.02.1203062243130.2742@ionos> <CA+55aFwTYRO-qOPvSPkEf_5=10EOTBQa+DpRHFf_=iwXOFi4xw@mail.gmail.com>
In-Reply-To: <CA+55aFwTYRO-qOPvSPkEf_5=10EOTBQa+DpRHFf_=iwXOFi4xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203070038.34767.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 07 March 2012, Linus Torvalds wrote:
> On Tue, Mar 6, 2012 at 2:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set
> 
> Ok, can we get this fixed version tested too by people who saw the problem?
> 
> Just to make sure..
[…]

This variant is also working fine on PIII/ coppermine and bcm4306/3.

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Regards
	Stefan Lippers-Hollmann
