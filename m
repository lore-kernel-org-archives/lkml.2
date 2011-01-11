Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1AKKl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:41:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42215 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1AKKlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fPo0ACPjDjJbOxNKJry9MbCjOAmJa3mgKf0zx7GKuzc6wlvaVWKMLk1UCsua6EYn3Q
         JPoEB2aHvhEWCqSRWKLc6NBpyv9fA0C9GewBuy1blAiOASRf5TfsjkhNfAemDYUvTkU2
         JliloZankR4Mkplb8NejY2tNV2o5Wny7VhetU=
MIME-Version: 1.0
In-Reply-To: <AANLkTim0UBNG6bVgBDQsrBhVjS0FSdLbwaipBZGkTeWF@mail.gmail.com>
References: <alpine.DEB.2.00.1101091110520.5270@tiger>
	<AANLkTim0UBNG6bVgBDQsrBhVjS0FSdLbwaipBZGkTeWF@mail.gmail.com>
Date: Tue, 11 Jan 2011 12:41:17 +0200
X-Google-Sender-Auth: a0zuUhtk2MOZnw53zxHxV9K9qHo
Message-ID: <AANLkTi=pvz-ou3_DK0dUSRYCARkwM_X9x7Xpnapjw_Ke@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.38
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jan 10, 2011 at 6:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> A cherry-pick really is nothing but "apply the same patch as a
> different commit".
>
> So there is no way to say "this is already there" - because it really
> isn't. It's a totally different thing. In fact, it would be very wrong
> to filter them out, both from a fundamental design standpoint, but
> also from a usability/reliability standpoint: cherry-picks are by no
> means guaranteed to be identical to the source - like any "re-apply
> the patch in another place" model, the end result is not at all
> guaranteed to be semantically identical simply due to different bases:
> the patches may not even be identical, and even if they are, the
> results of the code may depend on what else is going on.
>
> So don't think of cherry-picks as "the same commit". It's not, and it
> never will be. It's a totally separate commit, they just share some
> superficial commonalities.

OK, I did not know that. Thanks for the explanation!

Is cherry pick still sane from maintainer workflow point of view? I
used to do it the other way - merge bug fixes to an "urgent branch"
and then merge that to the "next branch". I changed my workflow to
apply the patches always to the "next branch" first and only cherry
pick to the "urgent branch" if necessary.

Am I doing it wrong?

                        Pekka
