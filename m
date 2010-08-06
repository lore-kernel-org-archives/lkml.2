Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0HFEUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:20:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab0HFEUa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100806023539.GA22774@gondor.apana.org.au>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> 
	<20100806014057.GA22395@gondor.apana.org.au> <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com> 
	<20100806023539.GA22774@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 21:20:02 -0700
Message-ID: <AANLkTimVOkAi1_G9B290fHRR3PbV4H9003VarAv_zbGn@mail.gmail.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr 
	problem
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Howells <dhowells@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:35 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
>
> Because it can save data.  Each cryptographic algorithm (such as
> AES) may have multiple impelmentations, some of which are hardware-
> based.

Umm. The _developer_ had better test the thing. That is absolutely
_zero_ excuse for then forcing every boot for every poor user to re-do
the test over and over again.

Guys, this comes up every single time: you as a developer may think
that your code is really important, but get over yourself already.
It's not so important that everybody must be forced to do it.

                      Linus
