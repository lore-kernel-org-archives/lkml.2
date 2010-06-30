Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0F3J0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:26:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0F3J0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:26:45 -0400
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, Ky Srinivasan <KSrinivasan@novell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1277885133.1868.71.camel@laptop>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
	 <1277885133.1868.71.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 11:26:36 +0200
Message-ID: <1277889996.1868.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 10:05 +0200, Peter Zijlstra wrote:
> > +config ENLIGHTEN_SPINLOCKS
> 
> Why exactly are these enlightened? 

Or did I just miss a terribly pun:
  enlightenment -> Buddha -> Zen -> Xen ?
