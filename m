Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1AMCOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 21:14:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37256 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1AMCOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 21:14:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xasHv0n8MZFvqy1/b9OoAh0PSW23WGhsFs1jtz6K+0xMMDcnIOE5cJNJjHiH0SpT83
         BneDHBEonOIdVH1jZfnG4UXivB3ugoZ43JIyhFYh2IBPSYwJGR4FTky/psNd1f5Tf6hz
         ysBqAkbAlRGGYqG2N2KRnbhHRVESytOVyQvXE=
MIME-Version: 1.0
In-Reply-To: <1294883313.2757.5.camel@perseus>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<1294804776.2821.4.camel@perseus>
	<AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
	<1294807279.2821.9.camel@perseus>
	<1294809426.2821.20.camel@perseus>
	<AANLkTikYErmu6bNz51iPgjzdOoa8uWNNdn01texihqM6@mail.gmail.com>
	<1294883313.2757.5.camel@perseus>
Date: Thu, 13 Jan 2011 13:14:14 +1100
Message-ID: <AANLkTin9ac1r_Hur4w=cxkCg2Z-JVYRCwsR6KeZ+9b=R@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, aelder@sgi.com,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 12:48 PM, Ian Kent <raven@themaw.net> wrote:
> On Thu, 2011-01-13 at 12:01 +1100, Nick Piggin wrote:
>> Hm, what are the concurrencies that you need protection from?
>
> Ha, I think I'm wrong about this, after looking more closely at this I'm
> struggling to see why autofs4_lock is needed at all.

Well you did send me a series of patches to remove it, but
unfortunately that was just as you made some larger changes
to autofs4 upstream and I wasn't able to keep them up to date.

It would be much appreciated if you had time to take another
look at all the locking and streamline it.

Thanks,
Nick
