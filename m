Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1JZBga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:36:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46506 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1JZBg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6v9ZsK9KqUyZR76b0n3pTs6ykkQUJ6UtWooH9QvoFi16A@mail.gmail.com>
References: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
 <201110211339.59280.arnd@arndb.de> <CACxGe6sFrJh+Y5CJVMTPiWH3m=j+J_YUzLP=MiaBbsvDkeA_Jg@mail.gmail.com>
 <201110251323.44313.arnd@arndb.de> <CACxGe6v9ZsK9KqUyZR76b0n3pTs6ykkQUJ6UtWooH9QvoFi16A@mail.gmail.com>
From: Hamo <hamo.by@gmail.com>
Date: Wed, 26 Oct 2011 09:36:05 +0800
Message-ID: <CAO_0yfOc2-ws7N7T9wzRmVG7iw2i0ASwvb6FS2ofk8Wzij0ofg@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 7:41 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> On Oct 25, 2011 1:23 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:
>> I would assume that this is what Hamo did:
>>
>> $ ./scripts/get_maintainer.pl -f include/asm-generic/gpio.h
>> Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/A...)
>> linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...)
>> linux-kernel@vger.kernel.org (open list)
>
> Hmmm, looks like MAINTAINERS needs an update. Gpio should have been picked
> up.
>
> Sorry Hamo.
>
> g.
>
>>
>>        Arnd

Just found your emails.  Yes I used the script. I have sent a patch to
update MAINTAINERS and cc to you Grant.

Thanks,
Yang
