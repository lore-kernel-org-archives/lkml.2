Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1DGTQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:16:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37368 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab1DGTQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
References: <20110331032307.GA27999@vigoh> <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh> <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
 <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 7 Apr 2011 16:16:31 -0300
Message-ID: <BANLkTi=SZ_h5OpHpR7oa=+in51UciJA+UA@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, lucas.de.marchi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 3:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Ok, I pulled it, but some checking shows that not all of the
> corrections are correct.
>
> For example:
>
>  @@ -557 +557 @@ struct sctp_ulpevent *sctp_ulpevent_make_send_failed(
>         * ressemble/resemble a fragmented message.
>
> (this is with "word diff"), the "ressemble" was corrected to
> "resemble". But the correct spelling in this case is actually
> "reassemble".

Ok, I'll disable the automatic fix for this one in codespell, so it
doesn't hides itself  with other fixes.


>
> Another example:
>
>  @@ -317 +317 @@ static struct clk timer2_clk = {
>          .usecount = 1,              /* REVISIT: why cant'can't' this
> be disabled? */
>
> where (cant') was changed into (can't') - notice the extra apostrophe
> (it used to be there, just transposed with the 't' - there were at
> least three of those).

Right.. the problem here is that  ' was considered a word boundary.

>
> Regardless, those were the only ones I _noticed_, there may well be
> others. I'd suggest people try to find more. The easiest way I found
> to go through it was:
>
>   git show -U0 --color-words 25985edcedea

This is awesome! Much easier than the --word-diff I was using. Thanks.

Lucas De Marchi
