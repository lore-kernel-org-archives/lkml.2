Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0F3Isz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:48:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41776 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0F3Isy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 04:48:54 -0400
Message-Id: <4C2B21300200007800008BDC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 09:49:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <jeremy.fitzhardinge@citrix.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -
	 improve yield behavior on Xen
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
 <1277885485.1868.74.camel@laptop>
In-Reply-To: <1277885485.1868.74.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 10:11, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-06-29 at 15:35 +0100, Jan Beulich wrote:
>> 
>> The (only) additional overhead this introduces for native execution is
>> the writing of the owning CPU in the lock acquire paths. 
> 
> Uhm, and growing the size of spinlock_t to 6 (or 8 bytes when aligned)
> bytes when NR_CPUS>256.

Indeed, I should have mentioned that. Will do so in an eventual
next version.

Jan

