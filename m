Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2LaOpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 09:45:33 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43114 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2LaOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 09:45:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1RGDV5fje8+sNQUCgJNKaasZ=pvg4rWrXaz-3cZ+uNgsWDzg@mail.gmail.com>
References: <1356754984-13917-1-git-send-email-roland@kernel.org>
	<20121229175625.GA1963@kroah.com>
	<1356811734.16149.1.camel@joe-AO722>
	<CAL1RGDV5fje8+sNQUCgJNKaasZ=pvg4rWrXaz-3cZ+uNgsWDzg@mail.gmail.com>
Date: Mon, 31 Dec 2012 15:45:31 +0100
Message-ID: <CAF6-1L54a1MB_7ERmTsXX=LY+ShfZ-fxoDsEwR8q2uj-EW_-nQ@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
From: Sylvain Munaut <s.munaut@whatever-company.com>
To: Roland Dreier <roland@purestorage.com>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> Sylvan Munaut did something similar
>> https://lkml.org/lkml/2012/12/5/168
>
> Missed that and duplicated the debugging :(
> Sorry Sylvain.

I should have followed up on the patch sooner, but I basically
finished testing it fixed all the issues and posted it just before
leaving for vacation and I just got back (and didn't check my work
email there).


> I guess my patch may be preferable, since I happened to use the snprintf()
> method that you suggest -- all the open-coded digit-counting seems a bit
> verbose and perhaps hard to read and see the equivalence to the sprintf.

Yes, I just did it that way to match the way if was done in other
parts of that file in ... the snprintf method is clearly more
readable.

Cheers,

    Sylvain
