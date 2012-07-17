Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2GQS5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:57:22 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36610 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2GQS5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120717171251.GD6049@thunk.org>
References: <1342524793-2522-1-git-send-email-sedat.dilek@gmail.com>
	<20120717171251.GD6049@thunk.org>
Date: Tue, 17 Jul 2012 20:57:19 +0200
Message-ID: <CACRpkdZe48FrDJx1p8ojfqwVBE95hSJipE8rViAi=E28uumYOQ@mail.gmail.com>
Subject: Re: [PATCH -next] random: Remove remaining relicts of rand_initialize_irq()
From: Linus Walleij <linus.walleij@linaro.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Sedat Dilek <sedat.dilek@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 7:12 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 17, 2012 at 01:33:13PM +0200, Sedat Dilek wrote:
>> rand_initialize_irq() was removed here:
>>
>> commit 946672f548682905d8ecdab33bb6e2c705418505
>> "random: remove rand_initialize_irq()"
>>
>> The AB3100 mfd-driver is the only driver still using it and breaks
>> with the following error-messages in linux-next (next-20120717)
>
> Oops.  Sorry, I thought I had caught all of the users of
> rand_initialize_irq().  Thanks for catching this!
>
> I'll take your advice and merge it into the original commit.

So the IRQ will be auto-sampled now or something?

Sorry for not quite following, which commit do I look at to
understand this now...

Yours,
Linus Walleij
