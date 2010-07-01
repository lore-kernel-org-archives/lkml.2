Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0GAH46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:56:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37467 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0GAH44 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Thu, 1 Jul 2010 03:56:56 -0400
Message-Id: <4C2C6680020000780000901E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 01 Jul 2010 08:57:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -
	 Xen  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
 <4C2B1769.5090107@goop.org>
 <alpine.DEB.2.00.1006301647220.30135@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1006301647220.30135@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 17:57, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
wrote:
> On Wed, 30 Jun 2010, Jeremy Fitzhardinge wrote:
>> On 06/29/2010 04:32 PM, Jan Beulich wrote:
>> > Use the (alternative instructions based) callout hooks to the ticket
>> > spinlock code to enlighten ticket locks when running fully virtualized
>> > on Xen. Ultimately, this code might also be a candidate to be used
>> > when running para-virtualized.
>> >
>> 
>> I'm not sure what the gain is by making this independent of all the rest
>> of the Xen support in the kernel.  Stefano is working on a series
>> (posted a few times now) to add more paravirtual features for Xen HVM
>> guests, and this work is conceptually very similar.
> 
> My series has been stable since a while now and contains all the basic
> PV on HVM mechanisms you need, including parsing the cpuid and mapping
> the shared info page.
> 
> Could you please rebase on my series (or at least the first two
> patches), so that we don't conflict with each other?

I really don't want to make those patches depend on no upstream
stuff (as I want it accepted upstream), and I'm not sure when your
patch series is expected to be upstream. If that's going to be soon,
I'd just re-base after it happened.

Jan

