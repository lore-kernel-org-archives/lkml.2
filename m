Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0F3I4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:39845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0F3I4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:56:34 -0400
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks - Xen
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <4C2B21D20200007800008BDF@vpn.id2.novell.com>
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
	 <1277885135.1868.72.camel@laptop>
	 <4C2B21D20200007800008BDF@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:56:20 +0200
Message-ID: <1277888180.1868.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 09:52 +0100, Jan Beulich wrote:
> > why is that a rwlock?, those things are useless.
> 
> Because potentially each CPU's lock gets acquired for reading during
> unlock, while only the locking CPU's one needs to be acquired for
> writing during lock. 

Can you say: scalability nightmare? but then its Xen code so who cares..

/me pretends he never saw it
