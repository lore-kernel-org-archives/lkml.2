Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1AGXfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:35:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1AGXfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:35:18 -0500
Message-ID: <4D27A329.7010801@suse.cz>
Date: Sat, 08 Jan 2011 00:35:05 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@linux.intel.com,
        akpm@linux-foundation.org, jonas.aberg@stericsson.com, julia@diku.dk,
        xiyou.wangcong@gmail.com, yann.morin.1998@anciens.enib.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT] kbuild misc updates for 2.6.38-rc1
References: <20110107230426.GA15371@sepie.suse.cz> <20110107232754.GB8237@pengutronix.de>
In-Reply-To: <20110107232754.GB8237@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.1.2011 00:27, Uwe Kleine-König wrote:
> Hi Michal,
> 
> On Sat, Jan 08, 2011 at 12:04:26AM +0100, Michal Marek wrote:
>> Uwe Kleine-König (1):
>>       tags: put function prototypes back!
> this is wrong.  It was Alexey who authored that patch.  I only pinged
> and forwarded it a few times.

Grr. You should added a second From: header to the message body in that
case, git am supports this. Rewinding the branch while Linus is possibly
reviewing it might not be a great idea. Alexey, how much would it hurt
you if the commit stayed as is?

Michal
> 
> If you care to fix that:
> 
> 	git filter-branch --env-filter 'if test "x$GIT_COMMIT" = "x0a18a9386c056028799938960f91be338c4ff349"; then GIT_AUTHOR_NAME="Alexey Dobriyan"; GIT_AUTHOR_EMAIL=adobriyan@gmail.com; export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL; fi' v2.6.37-rc1..misc
> 
> .  This is untested though, so you might want to double check the
> result.
> 
> Best regards
> Uwe
> 

