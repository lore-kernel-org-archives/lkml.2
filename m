Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1LNU4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:56:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:34584 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab1LNU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:56:29 -0500
Date: Wed, 14 Dec 2011 21:56:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5
 machine
In-Reply-To: <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1112142155590.3020@ionos>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com> <alpine.LFD.2.02.1112141423380.3020@ionos> <alpine.LFD.2.02.1112142116540.3020@ionos> <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Yinghai Lu wrote:
> On Wed, Dec 14, 2011 at 12:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > What's worse is that this problem exists on 3.2-rc5 as
> > well. Investigating.
> 
> 
> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?

Right. Just figured that out myself. Sigh ....
