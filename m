Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1BIRhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:37:48 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58154 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1BIRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:37:47 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "R. Herbst" <ruediger.herbst@googlemail.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Matt <jackdachef@gmail.com>,
        geert@linux-m68k.org
Subject: Re: Sun GEM PPC32 Bug?
References: <AANLkTin4ha5tkU_xgxkq7Kr6dG1-C2xR_04kBOrAngLH@mail.gmail.com>
	<1297056878.14982.65.camel@pasglop> <m2y65qe1ss.fsf@igel.home>
	<1297210693.14982.329.camel@pasglop>
X-Yow: I predict that by 1993 everyone will live in and around LAS VEGAS and
 wear BEATLE HAIRCUTS!
Date: Wed, 09 Feb 2011 18:37:42 +0100
In-Reply-To: <1297210693.14982.329.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Wed, 09 Feb 2011 11:18:13 +1100")
Message-ID: <m2r5bhw1ll.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Tue, 2011-02-08 at 20:58 +0100, Andreas Schwab wrote:
>> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>> 
>> > What's your machine model (cat /proc/cpuinfo) and what do you do to
>> > trigger the problem ? I'm trying to reproduce here and so far had
>> > no success doing so.
>> 
>> Just today I saw the same problem on my PowerMac G5, while sending a lot
>> of data over LAN.
>
> This isn't the same problem... this looks like a tx timeout. Or do you
> have some previous messages you didn't paste indicating that it all
> started with an RX overflow ? :-)

No, there was no RX overflow.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
