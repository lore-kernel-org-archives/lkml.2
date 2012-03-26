Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2CZUCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:02:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab2CZUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:02:13 -0400
Message-ID: <4F70CB12.3000104@zytor.com>
Date: Mon, 26 Mar 2012 13:01:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Maciej Rutecki <maciej.rutecki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Tracking regressions for next release(s)
References: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com> <20120323101431.GA8832@liondog.tnic> <201203261847.17521.maciej.rutecki@gmail.com> <20120326185849.GA19481@liondog.tnic>
In-Reply-To: <20120326185849.GA19481@liondog.tnic>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 11:58 AM, Borislav Petkov wrote:
> 
> Well, if you still can report your results from it, I think maintainers
> who are still interested in the quality of their code will be interested
> in your testing reports.
> 
> Thanks again for your work.
> 

I agree; it is very easy to lose track of regressions and it is really
useful to be reminded of them.  That doesn't mean, however, that all
bugzilla reports are useful or valid, but that doesn't mean the overall
effort isn't useful.

	-hpa

