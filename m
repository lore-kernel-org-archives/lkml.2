Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0G1Huz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:50:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34214 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0G1Hux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mCWTBa4Sc50F1Svzd9uD+iJC0W3YVWNFcSkVFIN4B+1WKoDPNzYWFGtJwFDU9cNfH2
         K1FiA7Es2a/L+SN0T1zQER0jCww32T3UAuTHtcvob7TNUydF44g9QogGFXGvAxj32bgV
         M5/JDTCm7pISCHOaxVmGkGR8T++DKxpBF6S+8=
MIME-Version: 1.0
In-Reply-To: <1280258531.24054.10.camel@Joe-Laptop.home>
References: <1280258531.24054.10.camel@Joe-Laptop.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Jul 2010 03:50:31 -0400
Message-ID: <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c: Use 
	pr_fmt, netdev_<level>
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 15:22, Joe Perches wrote:
> And some assorted neatening for checkpatch:
>
>        80 column reformatting (mostly comments)
>        argument alignment
>        couple of spelling/grammar typos corrected
>
> Added bfin_alloc_skb to centralize allocation/dcache invalidation
> Added get_mac_addr for symmetry
>
> $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
> total: 2 errors, 25 warnings, 1723 lines checked
> $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
> total: 0 errors, 0 warnings, 1743 lines checked
>
> Uncompiled, untested.

i dislike the mixing of whitespace and useful changes

if they were split, and they worked, then i wouldnt have a problem with them
-mike
