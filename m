Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1LLDNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:13:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1LLDNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:13:39 -0500
Date: Mon, 12 Dec 2011 04:11:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
Message-ID: <20111212031150.GB3201@elte.hu>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
 <4EE56E99.60801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE56E99.60801@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> > That said, if you've verified that if fails for you, I guess 
> > we should revert regardless. Matt, any suggestions for tests 
> > to do?
> > 
> 
> Also... I'd like to know what machines, if any, would break 
> without the patch, so we can figure out what has to be tested.

The offending commit has this bugzilla:

        https://bugzilla.redhat.com/show_bug.cgi?id=748516

Which says this about the orignal failing system:

| Additional info:
| From the affected system:
| dmidecode | grep -i product
|  Product Name: MacBookAir1,1
|  Product Name: Mac-F42C8CC8

Thanks,

	Ingo
