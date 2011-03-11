Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1CKAk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:40:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1CKAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZcVhJb6H+ROnCIGSWarnpp8Z95tDbDvrEmLsHrDYhON8+cvHtGF1ALCdcKUy7pCgXw
         lidJBYTx4sCL9xtt0Q+TmKyT2z0rP1MOtd1CeT61rh8q1qWLzxt7jT0RVIOBa9VLLooZ
         3DShquKFmX4YzcQVZQsIbUJMqnqdnsR1X1o1o=
MIME-Version: 1.0
In-Reply-To: <AANLkTiktUsR1vXo84H2m_tLZRgDGee+JdvxGZjX7hYMq@mail.gmail.com>
References: <20110310.153444.115930379.davem@davemloft.net>
	<AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
	<20110310.155556.48513201.davem@davemloft.net>
	<AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
	<AANLkTiktUsR1vXo84H2m_tLZRgDGee+JdvxGZjX7hYMq@mail.gmail.com>
Date: Fri, 11 Mar 2011 10:40:23 +1000
Message-ID: <AANLkTikiy+hNgG=BRWKkHEHCdvJnffWP6nhp1XxsEEO+@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:34 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 10, 2011 at 4:29 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Oh well. Water under the bridge. I think I'll try --no-ff this once,
>> despite my misgivings about the concept.
>
> Oh wow. That really does end up looking odd. I know some other git
> projects use --no-ff, but I don't think we've ever had them in the
> kernel, and I've never see the graph look like that before.
>
> But it did allow me to add an explanation for what happened, so maybe
> it's worth it.

I didn't realise we weren't meant to --no-ff, I've been lately using
--no-ff --log
so I can keep track of what I merged easier, when someone bases something on my
tree and I haven't moved it in a while.

Though I suppose author/committer info should tell me this I've found
having the logs
at least a bit useful.

Dave.
