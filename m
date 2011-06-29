Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1F2Xi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:38:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:51610 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1F2Xix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:38:53 -0400
Date: Thu, 30 Jun 2011 01:38:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
cc: Darren Hart <dvhart@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, mingo@elte.hu
Subject: Re: [PATCH v4] futex: Fix regression with read only mappings
In-Reply-To: <1309360644-24079-1-git-send-email-sbohrer@rgmadvisors.com>
Message-ID: <alpine.LFD.2.02.1106300129130.2917@ionos>
References: <4E0A6A0F.9020004@linux.intel.com> <1309360644-24079-1-git-send-email-sbohrer@rgmadvisors.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Shawn Bohrer wrote:
> 
> While fixing the regression this patch opens up a possible bad
> scenarios as identified by KOSAKI Motohiro:
> 
> This patch also allows FUTEX_WAIT on RO private mappings which have
> the following corner case.

These two sentences make no sense at all. We really need a very
accurate description of this change. That code is subtle and we really
want to have a very clear and understandable changelog.

Your changelog fails the basic test by mentioning "corner case" simply
because the whole futex code consists only of corner cases.

Thanks,

	tglx
