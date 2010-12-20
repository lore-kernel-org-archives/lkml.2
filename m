Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0LTJ45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:56:57 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:35464 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab0LTJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:56:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=uAzWn5vyCofQzViUAYzSVIkgosoA/FXg
	LIUl6UIHHNJXM/8OMeWeNk1B10Mc/JAjxUratdap2W7YBL02XFDczLFhYS571E2B
	pCOc4sio66R7UbLfkCg3eMidH6K+PtyKqZhcrRAnz3DadT8DvKYgfD39KbC0g84A
	4kq1qudtt2U=
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 2.6.37
References: <20100305071043.GA3548@gondor.apana.org.au>
 <20100427135547.GA4008@gondor.apana.org.au>
 <20100603100550.GA30681@gondor.apana.org.au>
 <20100716022648.GA28219@gondor.apana.org.au>
 <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <AANLkTikM4vQe7dsN8JJ1QSLeeTbRpSnuoJU=e4H2YFoz@mail.gmail.com>
 <20101216004938.GA32662@gondor.apana.org.au>
 <20101216005813.GA820@gondor.apana.org.au>
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 20 Dec 2010 01:56:40 -0800
In-Reply-To: <20101216005813.GA820@gondor.apana.org.au> (Herbert Xu's message
 of "Thu\, 16 Dec 2010 08\:58\:13 +0800")
Message-ID: <7vd3owdaxz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 888BE634-0C1F-11E0-8AC6-C4BE9B774584-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Dec 16, 2010 at 08:49:38AM +0800, Herbert Xu wrote:
>> On Wed, Dec 15, 2010 at 12:40:48PM -0800, Linus Torvalds wrote:
>> >
>> > There's a few other objects like that too. How do you push to your
>> > repo, and what changed?
>> 
>> Oops, I've fixed that now.  I use rsync to copy files across so
>> it's my end that has changed.  And indeed I've just done an upgrade.
>> Sorry.
>
> OK it should be fixed for got now.  I suspect what has changed
> is that git is now using my umask by default.

Sorry, do you mean I need to be aware of a regression in recent version of
git?  From which version to which version of git did you upgrade?  

I offhand do not recall any recent change around umask area, especially
with respect to rsync transport.
