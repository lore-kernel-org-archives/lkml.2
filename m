Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0JAVSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:18:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:47625 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab0JAVSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:18:30 -0400
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <AANLkTi=C+tti-08iti=o-fJG2rj7W5EGvB75u6njz2w9@mail.gmail.com>
References: <20100930221351.682772535@linutronix.de>
	 <20100930221743.014571381@linutronix.de> <1285893737.2463.4.camel@pasglop>
	 <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
	 <1285965973.2463.129.camel@pasglop>
	 <AANLkTi=C+tti-08iti=o-fJG2rj7W5EGvB75u6njz2w9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 07:17:31 +1000
Message-ID: <1285967851.2463.174.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 06:11 +0900, Grant Likely wrote:
> 
> Before doing that, I'd like to see what data members are still needed.
>  The powerpc use-case is quite sane, and it may turn out to be common
> code after all.  I certainly want to port the PowerPC functionality to
> ARM. 

Pretty much the host (domain) pointer and the associated HW number. The
later might want to be an arch typedef tho (on ppc64 at least it wants
to be 64-bit), and that's it.

Cheers,
Ben.



