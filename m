Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0IHO0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:26:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58741 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0IHO0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S5LAafemwpP6/J1VFRzzMnikwB+eZejQGBoNjjoODLG22nh9Te3A6ItGJMfxgUrAiF
         g0/nyz/DY5ZvvkKL0sdoTr6HI9tQcUWqzybP9oKp3nOzcnl4eGuMHe1mDj5ckRevB/fw
         Tc/WhN8ZV4DropxXhp672Y8nouhYBSRITFiwU=
MIME-Version: 1.0
In-Reply-To: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 8 Sep 2010 16:26:12 +0200
Message-ID: <AANLkTi==kKBdOaim+fx5yhpKOo27HWhB7kQiDqv0+BPS@mail.gmail.com>
Subject: Re: [00/12] DMAENGINE: PL08X driver updates
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/31 Linus Walleij <linus.walleij@stericsson.com>:

> This updates the PL08X driver in the async_tx next branch with
> a number of fixes and features, each one pretty self-describing.
> This has been tested with the PrimeCell DMA series on the
> RealView PB11MPCore and works flawlessly, multiplexing
> several virtual clients, both devices (slaves) and memcpy
> channels, across only two (!) available physical channels.

Dan can you ACK and queue this for next?

I know you're busy, just a reminder...

Yours,
Linus Walleij
