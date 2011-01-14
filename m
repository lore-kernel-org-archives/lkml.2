Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1ANVpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:45:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50752 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1ANVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d7IWe2CulchvEMF2t6B95V5sXaQy3lRrtj+rA32E/75u3V/GJ8XUp97G7WiBYxp5QB
         BlZJsjWpQNjYBTXHugiCbQ5i0kxiqywiRNw2REk9MBha7zCJxoL5k62gL+MKkVQr/4O2
         sp+Oxx4KBnEAZfrPHzH313zWBgIUyvBCdnGqU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101141740120.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
	<8952.1294927845@jrobl>
	<alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
	<AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com>
	<alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
	<AANLkTinAseKuc3=JxB2qZGz2D4KUyjj=dbnoKfSyVLqh@mail.gmail.com>
	<alpine.LFD.2.00.1101141740120.2678@localhost6.localdomain6>
Date: Sat, 15 Jan 2011 08:44:54 +1100
Message-ID: <AANLkTi=JS0B-G_QvwDLjTNYg4CLmitM_MN3A8g2UL0Uf@mail.gmail.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
From: Nick Piggin <npiggin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 3:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 14 Jan 2011, Linus Torvalds wrote:
>
>> On Fri, Jan 14, 2011 at 1:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > Can you point us to the patches, so we can run our own set of
>> > tests in paralell?
>>
>> They should be in current -git as of yesterday evening.
>>
>> In particular, I think this one is commit 90dbb77ba48d.
>
> Yep, that works - though it needs the pending fixes from Nick latest
> pull request as well

Thanks for reporting and testing.

Nick
