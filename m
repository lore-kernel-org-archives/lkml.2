Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1FUGzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 02:55:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45242 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1FUGzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 02:55:51 -0400
Date: Tue, 21 Jun 2011 12:25:42 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ryan Mallon <rmallon@gmail.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of
 arbitrary physical addresses
Message-ID: <20110621065542.GA13432@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <201106171038.25988.ptesarik@suse.cz>
 <20110617093032.GA19235@elte.hu>
 <4DFE7FF9.9070406@gmail.com>
 <4DFE89E0.5020509@zytor.com>
 <20110620074124.GB24716@elte.hu>
 <4DFF6E58.8090306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF6E58.8090306@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 08:59:20AM -0700, H. Peter Anvin wrote:
> We should either fix /dev/mem to work according to its specification or
> rip it out.  The issue with test drivers is not spurious... I ran into
> this one myself a few weeks ago while trying to do a memory test (by
> limiting the amount of memory available to the kernel).  This is
> something that is typically done on factory floors, and it would be nice
> to be able to get those environments over to using Linux.

We came across a similar request from our manufacturing folks. They have a
memory stress tool that needs to test how much bandwidth is possible between
various cpus and memory modules. Essentially they want the tool to run on some
chosen CPU and want it to drive traffic to some chosen memory module.

/dev/mem would be handy for such test programs ..

- vatsa
