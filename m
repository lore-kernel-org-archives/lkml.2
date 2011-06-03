Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1FCTGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:06:03 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:44671
	"EHLO CH1EHSOBE017.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755463Ab1FCTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:06:00 -0400
X-SpamScore: -17
X-BigFish: VS-17(zz9371M1102K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 13:53:03 -0500
From: Scott Wood <scottwood@freescale.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Timur Tabi <timur@freescale.com>, <alan@lxorguk.ukuu.org.uk>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
Message-ID: <20110603135303.0800e4a7@schlenkerla.am.freescale.net>
In-Reply-To: <BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
	<4DE9294B.3040501@freescale.com>
	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 21:39:28 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Jun 3, 2011 at 9:34 PM, Timur Tabi <timur@freescale.com> wrote:
> > Would it be better if I did this:
> 
> The point is data should cross kernelspace/userspace boundary only once.
> 

Why does it matter, as long as it doesn't hurt the kernel if userspace
plays games (i.e. take care of the NUL termination), and it's not a
performance problem?

-Scott

