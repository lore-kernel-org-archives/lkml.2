Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0JCQyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:54:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46605 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab0JCQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:54:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
	<20100930221743.014571381@linutronix.de>
	<1285893737.2463.4.camel@pasglop>
	<alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
Date: Sun, 03 Oct 2010 09:53:56 -0700
In-Reply-To: <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
	(Thomas Gleixner's message of "Fri, 1 Oct 2010 15:07:19 +0200 (CEST)")
Message-ID: <m1bp7bfc9n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

>> That would make things much cleaner and in fact move one large step
>> toward being able to make powerpc virq scheme generic, which seems to be
>> a good idea from what I've heard :-)
>
> Yep.

I'm not certain about making the ppc virq scheme generic.  Maybe it is
just my distorted impression but I have the understanding that ppc irq
numbers mean nothing and are totally unstable whereas on x86 irq numbers
in general are stable (across kernel upgrades and changes in device
probe order) and the irq number has a useful hardware meaning.  Which
means you don't have to go through several layers of translation tables
to figure out which hardware pin you are talking about.

Eric
