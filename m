Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab0LFFgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:36:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62074 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0LFFgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:36:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N5NKt2bIIh1ICzPA4wqLIFF0kzGqcm7s/7aR45ZVG7r1Ah6ipP58RisSDw6/A+QoLP
         QOtKdeEIWfmsPaodeiq8Cp7f9jm/EdVTJATko/WONl54OIuNBQuDnJyTvqQBQJhd2SxZ
         AdBj3nOWXHPDNbUQBaBJDebHJAEsihi+R4IuU=
MIME-Version: 1.0
In-Reply-To: <20101204172840.GC10282@kroah.com>
References: <20101203210719.GB21223@windriver.com>
	<20101204172840.GC10282@kroah.com>
Date: Mon, 6 Dec 2010 14:35:59 +0900
Message-ID: <AANLkTint4xffGN4RJJ=Rn2XK--AAbM-2MEaVezzV7xJr@mail.gmail.com>
Subject: Re: Announcement: Plans for v2.6.34-longterm
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 2:28 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
>> With that in mind, it is our intention to also maintain a 2.6.34
>> longterm tree.  Jason and I work at Wind River, which already has
>> released products based on v2.6.34, and as such it only makes sense
>> to have a public long-term tree that others who are also based on
>> 2.6.34 can make use of.
>
> Other than Wind River, what other distros/userbases are using .34 as a
> platform for their products?

I am not sure companies/platforms(Sony, Google, Meego, and Linaro)
mentioned below article really made a promise to produce product.
Article said, they decided 2.6.35 with flag version.
If it were real, I think flag version impact would be big on embedded
system(To be honest, alone android is enough big)
Cced Tim.

http://lwn.net/Articles/413341/

Thanks for you effort, Good Luck, Paul. :)
-- 
Kind regards,
Minchan Kim
