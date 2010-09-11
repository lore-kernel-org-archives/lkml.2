Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0IKH3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 03:29:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0IKH3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 03:29:21 -0400
Date: Sat, 11 Sep 2010 09:29:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 08/43] memblock/microblaze: Use new accessors
Message-ID: <20100911072905.GA26366@elte.hu>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
 <1281071724-28740-9-git-send-email-benh@kernel.crashing.org>
 <4C5BCD41.3040501@monstr.eu>
 <1281135046.2168.40.camel@pasglop>
 <4C88BD8F.5080208@monstr.eu>
 <20100909115445.GB16157@elte.hu>
 <1284106711.6515.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284106711.6515.46.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Yep, i asked benh to have a look (see the mail below) but got no 
> > response, as i assumed it had all been taken care of.
> 
> Sorry, I must have been confused... I had pushed out a git branch a 
> while back with those updates and the ARM bits, at least I think I did
> :-) I might have FAILed there. I'll check next week, I'm about to 
> board on a plane right now.

Note, i applied the build error fixes from Yinghai. Please double-check 
things once you have the time.

Thanks,

	Ingo
