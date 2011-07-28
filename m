Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1G1OTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53014 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1G1OTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:19:36 -0400
Message-ID: <4E316FC5.7090201@zytor.com>
Date: Thu, 28 Jul 2011 07:18:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com> <20110724172222.GB12621@aftab> <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com> <20110727171015.GD19477@aftab> <4E3047D4.2000608@zytor.com> <20110728134416.GA26379@aftab> <4E316C06.2020609@zytor.com> <20110728141348.GB26379@aftab>
In-Reply-To: <20110728141348.GB26379@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 07:13 AM, Borislav Petkov wrote:
> 
> You want them to be _GENMASK{,_UL,_ULL}? Why? Because they're "calling"
> macros with a single underscore? Actually, I've always wondered on what
> our exact rules on underscores are. I can deduce the nesting level of
> macros based on number of underscores but what else?
> 

Internal symbols used in userspace-visible headers must be from the
namespace:

	^_[A-Z_].*

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

