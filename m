Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1EIO2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:28:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34496 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1EIO2m convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Mon, 9 May 2011 10:28:42 -0400
Message-Id: <4DC81635020000780004072A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 09 May 2011 15:28:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ian Campbell" <Ian.Campbell@eu.citrix.com>,
        "Kevin Tian" <kevin.tian@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
	 fixup_irqs
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com>
 <20110506135828.GC5500@dumpdata.com>
 <alpine.LFD.2.02.1105091437500.2843@ionos>
In-Reply-To: <alpine.LFD.2.02.1105091437500.2843@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.05.11 at 14:39, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 6 May 2011, Konrad Rzeszutek Wilk wrote:
>> On Fri, May 06, 2011 at 02:43:36PM +0800, Tian, Kevin wrote:
>> > because Xen event chip silently fails the set_affinity ops, and
>> > logically IRQF_PER_CPU should be recognized here.
>> 
>> OK, so what if the set_affinity ops was implemented?
> 
> An interrupt chip which has a set_affinity op should not mark
> something per cpu, which implies that the irq CANNOT be moved.

Why shouldn't it be possible o use the same "chip" for both per-CPU
and "normal" IRQs?

Jan

