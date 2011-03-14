Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1CNOXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:23:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab1CNOXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:23:37 -0400
Date: Mon, 14 Mar 2011 15:23:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Hockin <thockin@google.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Mike Waychison <mikew@google.com>,
        Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
Message-ID: <20110314142315.GA1638@elte.hu>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
 <4D7D9F92.5010604@kernel.org>
 <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
 <4D7DA16F.5010601@kernel.org>
 <20110314092220.GA18058@elte.hu>
 <AANLkTikXE+rMj1GHqZq6YpZOj1_PQJ-K4t8WeVKgsG_B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikXE+rMj1GHqZq6YpZOj1_PQJ-K4t8WeVKgsG_B@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Hockin <thockin@google.com> wrote:

> This same BIOS logic is used across a number of Platforms.  We could
> use something like the vendor strings to trigger this code off, [...]

Correct.

> [...] I suppose, but ick.  It's already in a google/ subdir and wrapped with 
> CONFIG_GOOGLE_MEMCONSOLE.

That's not the point though - in this day and age we simply do not add non-generic 
hacks like that - we've come a long way since the ISA days. The point is to make it 
safe enough to limit its effects not just to CONFIG_GOOGLE_MEMCONSOLE but also to 
affected hardware only.

Thanks,

	Ingo
