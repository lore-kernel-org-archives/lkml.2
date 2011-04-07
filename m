Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab1DGS3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:29:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756236Ab1DGS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
References: <20110331032307.GA27999@vigoh> <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh> <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Apr 2011 11:28:43 -0700
Message-ID: <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, lucas.de.marchi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 7:17 AM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Hi Linus,
>
> On Thu, Mar 31, 2011 at 11:44 AM, Lucas De Marchi
> <lucas.demarchi@profusion.mobi> wrote:
>> I've created a new patch, removing the copyright changes. New
>> patch can be pulled from:
>>
>> git://git.profusion.mobi/users/lucas/linux-2.6.git for-linus2
>
> Maybe you could consider this patch now that rc2 is out? It still
> applies cleanly on top of -rc2.

Ok, I pulled it, but some checking shows that not all of the
corrections are correct.

For example:

  @@ -557 +557 @@ struct sctp_ulpevent *sctp_ulpevent_make_send_failed(
  	 * ressemble/resemble a fragmented message.

(this is with "word diff"), the "ressemble" was corrected to
"resemble". But the correct spelling in this case is actually
"reassemble".

Another example:

  @@ -317 +317 @@ static struct clk timer2_clk = {
          .usecount = 1,              /* REVISIT: why cant'can't' this
be disabled? */

where (cant') was changed into (can't') - notice the extra apostrophe
(it used to be there, just transposed with the 't' - there were at
least three of those).

Regardless, those were the only ones I _noticed_, there may well be
others. I'd suggest people try to find more. The easiest way I found
to go through it was:

   git show -U0 --color-words 25985edcedea

which makes it reasonably dense and easy to see.

                      Linus
