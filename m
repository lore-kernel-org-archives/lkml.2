Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0ESFxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:53:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0ESFxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tNLfCWRh/YWTLjaSkF1U3+Xh8qP/1m92i9TrIq9OrCm7SOfcbgkJwTN7wTHYh7C2qE
         t+3JDK+EZfk8Z2cvPL+nMX0rVBMsxN53yeOjq59ew1qjYIR2LvHUHCuWrpyDJJP8asRU
         U82lXpqxFmtKqPVYAOx+jRruuknChMUkO2SNM=
MIME-Version: 1.0
In-Reply-To: <20100518.154059.139137292.davem@davemloft.net>
References: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <20100518223507.GB5933@linux-sh.org>
	 <20100518.154059.139137292.davem@davemloft.net>
Date: Wed, 19 May 2010 08:53:41 +0300
X-Google-Sender-Auth: YbIUQqsBBxnXX94SF-JoXEU2qD4
Message-ID: <AANLkTil4bdUVF0eNiBZl6pIMZH-ERwJxh6sq6SSHI0kb@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Miller <davem@davemloft.net>
Cc: lethal@linux-sh.org, mpm@selenic.com, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, May 19, 2010 at 1:40 AM, David Miller <davem@davemloft.net> wrote:
> I don't even know of a 32-bit chip outside of x86 that doesn't
> potentially emit alignment requiring 64-bit memory operations for
> 64-bit objects.  So what SLOB is doing with a different default is
> even more strange.  And I bet you that even without the requirement,
> x86 runs faster with 64-bit alignment of 64-bit objects.

Faster, sure, but SLOB is not about being fast, it's about being space
efficient.

                        Pekka
