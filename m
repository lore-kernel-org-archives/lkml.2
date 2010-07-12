Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0GLKXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:23:42 -0400
Received: from www.tglx.de ([62.245.132.106]:40074 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0GLKXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:23:41 -0400
Date: Mon, 12 Jul 2010 12:20:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Michal Hocko <mhocko@suse.cz>, stable@kernel.org,
        Darren Hart <dvhltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
In-Reply-To: <20100708132233.GA17473@elte.hu>
Message-ID: <alpine.LFD.2.00.1007121220260.2798@localhost.localdomain>
References: <20100708125104.GD4925@tiehlicka.suse.cz> <20100708132233.GA17473@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, Ingo Molnar wrote:

> 
> * Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hi stable team,
> > could you consider including the following patch (Linus tree commit:
> > 7a0ea09ad5352efce8fe79ed853150449903b9f5).
> 
> Ack.

Ack

	tglx
