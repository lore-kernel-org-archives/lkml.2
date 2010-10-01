Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0JAUff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:35:35 -0400
Received: from www.tglx.de ([62.245.132.106]:41613 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab0JAUfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:35:34 -0400
Date: Fri, 1 Oct 2010 22:35:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <4CA57795.4040308@kernel.org>
Message-ID: <alpine.LFD.2.00.1010012233410.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <4CA57795.4040308@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1581523691-1285965305=:14550"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1581523691-1285965305=:14550
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Thu, 30 Sep 2010, Yinghai Lu wrote:
> On 09/30/2010 04:14 PM, Thomas Gleixner wrote:
> kernel/irq/irqdesc.c:374: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘{’ token
> kernel/irq/irqdesc.c:377: error: expected ‘{’ at end of input
> make[1]: *** [kernel/irq/irqdesc.o] Error 1

Yeah, I fat fingered the queue in the last moment :( Fixing the mess right now.

Thanks,

	tglx
e 
---1463795968-1581523691-1285965305=:14550--
