Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0ERLRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:17:30 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60393 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0ERLR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:17:29 -0400
X-Greylist: delayed 105565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 07:17:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dq8fek/ZAB2c3EA9z2al+9ka/YCnFxkbWZFfROPCzwbjLdTcLWRpDQDO/Dyj1plyt7
         4tqzBYHdpHsv21IZQkzTUJdvh9i+KTRp7yQe7ROaUsPoyP3p66S7ufxDzRo30sQVl0Ls
         OrxRpTUOgowWW5esjJXD+37rgvMy024933iac=
MIME-Version: 1.0
In-Reply-To: <AANLkTilNQwo1YYT2pNJN5X0ae98iMKCdsBkcogjKZm-f@mail.gmail.com>
References: <20100518092532.GA3050@linux-sh.org>
	 <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com>
	 <20100518101500.GA3156@linux-sh.org>
	 <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
	 <AANLkTindMQ3Clk_qVnwUNYbbWcXjsUyyy4fQsjdDflFt@mail.gmail.com>
	 <AANLkTilNQwo1YYT2pNJN5X0ae98iMKCdsBkcogjKZm-f@mail.gmail.com>
Date: Tue, 18 May 2010 20:17:28 +0900
Message-ID: <AANLkTikPCCF3CDxozbPgiRFy2s5OX19oVrApsKhLnwqt@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
From: Magnus Damm <magnus.damm@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Tue, May 18, 2010 at 8:16 PM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> I am looking at the future, where multiple architecture will use each
> other files.
>
> I am just worried about the file count. Currently :
>
> $ ls include/linux/ | wc -l
> 1029
>
> If other architecture will also start adding the files in
> include/linux like you did then ?
>
> So better make another directory in include.

Perhaps we can deal with that whenever it becomes an issue.

Thank you.

/ magnus
