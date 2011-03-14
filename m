Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1CNJWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:22:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1CNJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:22:47 -0400
Date: Mon, 14 Mar 2011 10:22:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Tim Hockin <thockin@google.com>, Mike Waychison <mikew@google.com>,
        Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
Message-ID: <20110314092220.GA18058@elte.hu>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
 <4D7D9F92.5010604@kernel.org>
 <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
 <4D7DA16F.5010601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7DA16F.5010601@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@kernel.org> wrote:

> On 03/13/2011 09:58 PM, Tim Hockin wrote:
> > "Sufficient" or not, that's how the BIOSes we've got work.  We can't
> > retrofit that.
> 
> Uhm... what about, say, a DMI signature?

Yes - how does the dmidecode output look like on such a box?

Thanks,

	Ingo
