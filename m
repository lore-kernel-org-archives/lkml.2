Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0GHNWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:22:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0GHNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:22:47 -0400
Date: Thu, 8 Jul 2010 15:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Hocko <mhocko@suse.cz>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
Message-ID: <20100708132233.GA17473@elte.hu>
References: <20100708125104.GD4925@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708125104.GD4925@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Hocko <mhocko@suse.cz> wrote:

> Hi stable team,
> could you consider including the following patch (Linus tree commit:
> 7a0ea09ad5352efce8fe79ed853150449903b9f5).

Ack.

	Ingo
