Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0JAOSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:18:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0JAOSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oQmVhtaCQp7tkRf8CKdYdi9+Uq/Mt11q373LJLTuc+10ZzmbTsXILY5tb7Or3uheSk
         z5kwcs46gf6KVJd8vRf6cJaJnovOBFSE8rtNpyTzQ885pDt2kWmG/x758y0G29PgwP/I
         eLhqpwuwCHyo4yH/DRM1J8LhZ7RKFnoGoZu8A=
MIME-Version: 1.0
In-Reply-To: <20101001140918.GU21564@trinity.fluff.org>
References: <20101001140619.28d96040@endymion.delvare>
	<AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
	<20101001140918.GU21564@trinity.fluff.org>
Date: Fri, 1 Oct 2010 23:18:49 +0900
X-Google-Sender-Auth: d004xdhCZ-LllJvHzzXW5U-1G8w
Message-ID: <AANLkTikvXe5ZHCqqtfkAWu=78HWe0BD=suDMGETwd+hC@mail.gmail.com>
Subject: Re: [GIT PULL] i2c fixes for 2.6.36
From: Kyungmin Park <kmpark@infradead.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 11:09 PM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Fri, Oct 01, 2010 at 10:38:46PM +0900, Kyungmin Park wrote:
>> Hi Jean,
>>
>> Even though it's not yet acked from Ben. It should be fixed for
>> correct operation.
>> Without this patch, some I2C device doesn't work correctly.
>> http://www.spinics.net/lists/linux-i2c/msg04016.html
>
> It was in my last pull request to Linus.
Thanks Ben,

To Ben,
Do you have a plan to use notification mail or  confirm mail to ensure
these patches are merged or not.
I think it's helpful to your maintained subsystem participants. e.g,
samsung soc, sdhci-s3c, i2c and so on.

Thank you,
Kyungmin Park

>
> --
> Ben
>
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.
>
>
