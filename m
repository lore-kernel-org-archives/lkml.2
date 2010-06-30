Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0F3LtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:49:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0F3LtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:49:00 -0400
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <4C2B4A100200007800008CC5@vpn.id2.novell.com>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
	 <1277885133.1868.71.camel@laptop>
	 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
	 <1277889116.1868.95.camel@laptop> <4C2B14BE.6080505@goop.org>
	 <4C2B4A100200007800008CC5@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 13:48:45 +0200
Message-ID: <1277898525.1868.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 12:43 +0100, Jan Beulich wrote:

> It does tickle just the new owner - that's what the list is for.

But if you have a FIFO list you don't need the ticket stuff and can
implement a FIFO lock instead.
