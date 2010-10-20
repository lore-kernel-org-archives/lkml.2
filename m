Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0JTL1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:27:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64279 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0JTL1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A0pRxaZ8NvpfdWMWuD9ProDtyG1Q3AWiclJxC9hL61ni4R18meyvslPAqvX7FJSOxU
         hchxuifaPiRjz3UiGfmAs+EQPDLJth/kNmoJRXohwQaBU700EsKVWrIF5K7B8W/YtJgI
         amOrcvL9iMPrZS9/vZz7r8d8nl1olYE7RnrB4=
MIME-Version: 1.0
In-Reply-To: <20101019170342.GA18575@kroah.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
	<20101019170342.GA18575@kroah.com>
Date: Wed, 20 Oct 2010 14:27:13 +0300
Message-ID: <AANLkTimdFBLHXh0neU4j3aKf4u1rrOjVmNB+qHcRbmkr@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: batman-adv: remove useless addr_to_string()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for that. Resend new version checked by both compilation and sparse.

On Tue, Oct 19, 2010 at 8:03 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Oct 16, 2010 at 01:11:10PM +0300, Andy Shevchenko wrote:
>> Since all *printf() methods in the kernel understand '%pM' modifier the
>> conversion to the string is useless beforehand.
>>
>> Additionally this patch decreases batman_if structure by 20 bytes.
>
> And also, it breaks the build:
>        drivers/staging/batman-adv/vis.c: In function ‘vis_data_read_entry’:
>        drivers/staging/batman-adv/vis.c:170:38: error: ‘to’ undeclared (first use in this function)
>        drivers/staging/batman-adv/vis.c:170:38: note: each undeclared identifier is reported only once for each function it appears in
>
> Please always test your patches :(
>
> I've dropped this one.
>
> thanks,
>
> greg k-h
>



-- 
With Best Regards,
Andy Shevchenko
