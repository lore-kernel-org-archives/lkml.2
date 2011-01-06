Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1AFXCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:02:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1AFXCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:02:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wNPsdRgCRYyYajfajRPaZ0nRtxDd47krJP52/xqgPgcJtjrkoAEgZNYwbCSI9Iyww0
         5mAiXCoPnuORBO/A03dAbsV0fArTG9c7jgVIIfNK0r+dlVB1zu3MbyxkWbPWKoDJYotn
         ijVdHIH9UwyGpejmGGfx8dYJVqhwGU1lZAem0=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Crypto Update for 2.6.38
Date: Fri, 7 Jan 2011 01:02:25 +0200
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20081225002020.GA2912@gondor.apana.org.au> <20110106211645.GA26184@gondor.apana.org.au> <4D26381A.8040901@gnu.org>
In-Reply-To: <4D26381A.8040901@gnu.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101070102.26927.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 January 2011 23:46:02 Pavel Roskin wrote:
> On 01/06/2011 04:16 PM, Herbert Xu wrote:
> > This is also why only hash and skcipher are supported as they
> > are the main algorithm types supported by teh current async
> > drivers in the kernel.
> 
> Are there any chances AEAD will be supported?  Is the API extendable to
> allow that?
> 
> If I remember correctly, the original patch was simply a port of FreeBSD
> /dev/crypto, which doesn't support AEAD.

If it's meant to work like the FreeBSD /dev/crypto, then maybe this[1] paper 
is worth mentionning, which includes some performance numbers. There was a 
single thing that drew my attention, from "Drawbacks and problems [of 
userspace crypto]": "Lots of scary code-duplication".

[1] http://www.paeps.cx/pubs/crypto_acceleration/slides.pdf

-- 
Mihai Donțu
