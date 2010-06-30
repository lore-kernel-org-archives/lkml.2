Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0F3IGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:06:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0F3IFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:05:53 -0400
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks - Xen
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, Ky Srinivasan <KSrinivasan@novell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C2A200F02000078000089E4@vpn.id2.novell.com>
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:05:35 +0200
Message-ID: <1277885135.1868.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:32 +0100, Jan Beulich wrote:
> +static DEFINE_PER_CPU(arch_rwlock_t, spinning_rm_lock) = __ARCH_RW_LOCK_UNLOCKED;

why is that an arch_ lock?
why is that a rwlock?, those things are useless.
