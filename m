Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0KPHhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:37:55 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42991 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0KPHhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FSwcDWuqtL4Y8s636bjr3e6smTXloowDV6nKrnVxR/XI+3KuvFofH8rszEr+tzAshk
         l+7rc3lLUSDEzLdM7TamODHbFL5tK9Qnxc7lTTANY+rIfOu1gpV4YO0A7ZU4vEO26YCu
         w72DOFHi7NHHOvZ1/C2fmPV3L1VU5H1YXuuHE=
MIME-Version: 1.0
In-Reply-To: <1289892645.28741.8.camel@Joe-Laptop>
References: <cover.1289855436.git.joe@perches.com>
	<223eff1b1e8c4d1791af56113d088b379a93780b.1289855436.git.joe@perches.com>
	<AANLkTi=1XasDJaaisZ=NnL3Yv5tx+vhuifCuq7e-0PMe@mail.gmail.com>
	<1289892645.28741.8.camel@Joe-Laptop>
Date: Tue, 16 Nov 2010 08:37:53 +0100
Message-ID: <AANLkTi=qf9SNqFuomonUSWCSgYBB8kUfLdjVfZeXKhC4@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/staging: Remove unnecessary casts of netdev_priv
From: Belisko Marek <marek.belisko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 8:30 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2010-11-16 at 08:20 +0100, Belisko Marek wrote:
>> On Mon, Nov 15, 2010 at 10:12 PM, Joe Perches <joe@perches.com> wrote:
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> If I do: grep -r -n 'netdev_priv' drivers/staging/*/*[ch]
>
> Try:
>
> $ grep -rP --include=*.[ch] "=\s*\([^\*]+\*\s*\)\s*netdev_priv" drivers/staging
>
>> there is a more netdev_priv occurences ;)
>
> I'm sure there are, but probably not assigns.
Right. Just want to be sure ;)
> If you find more unnecessary casts, by all means submit them.

>
> cheers, Joe
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
