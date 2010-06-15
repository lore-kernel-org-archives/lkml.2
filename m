Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0FOHC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:02:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49101 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0FOHCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:02:54 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 03:02:53 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p4MFCVknU33W6fzh9fC139fOB6AGqmv+GFCmxFzXOQ04bmPyMLaceUgPi5Ad8FiAUH
         SZGILHOrjikYjrKVz4jdTeT59lj5lBMUv49lKf2I61Q9egxL1R0ehtc1uI4wzRQYrF27
         /1YnAPGA/T0g6UUQch5kVQu8vdk5Eumqc2qk8=
MIME-Version: 1.0
In-Reply-To: <20100615125512.09c79d9b.sfr@canb.auug.org.au>
References: <20100615125512.09c79d9b.sfr@canb.auug.org.au>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 15 Jun 2010 14:54:58 +0800
Message-ID: <AANLkTilwnVs1970j0DkobtpyDKY8mOX9EX6iFP2uSvYR@mail.gmail.com>
Subject: Re: linux-next: manual merge of the battery tree with the arm-current 
	tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Huang Weiyi <weiyi.huang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Anton,
>
> Today's linux-next merge of the battery tree got a conflict in
> drivers/power/z2_battery.c between commit
> 56b925fccc58cd43fc553a8302dbbdd440aef288 ("[ARM] pxa/z2: fix missing
> include in battery driver") from the arm-current tree and commit
> 5d111107b7994349feb681466f873b1a4f8a09d6 ("z2_battery: Remove duplicated
> #include") from the battery tree.
>
> The former is a superset of the latter.

Marek has submitted a revised patch which goes into the -pxa tree
due to dependency of z2_battery and some of the pxa machine files.

Anton,

Any suggestion? Or if you feel OK for this to go through the -pxa tree, I'd
like to have your Ack.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
