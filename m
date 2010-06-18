Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab0FRPZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:25:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63305 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0FRPZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JlPU231pnWDb7VKmYyTHZ3fNMZ4dSsnltg+FKtiYldCzBB7fMFqkTb74fjac0eN6Km
         pYMy6T9sP3hjxnZ0tU0WFguS6/AH4iyQcB2GWWB6jiBGY9bIaONkqBWZWIksrftzLfO4
         Vvq8+Dcb7EEEeMbvO8K4xrbZAgrThS3+UPvco=
MIME-Version: 1.0
In-Reply-To: <s5h4oh07d75.wl%tiwai@suse.de>
References: <4BC4E812.6050602@tremplin-utc.net>
	<s5h633u5zx1.wl%tiwai@suse.de>
	<4BC5A566.8060106@tremplin-utc.net>
	<s5hy6gqvx9n.wl%tiwai@suse.de>
	<4BC782E5.7070900@tremplin-utc.net>
	<4BC9D1E9.1090705@roadrunner.com>
	<loom.20100617T221709-460@post.gmane.org>
	<s5h4oh07d75.wl%tiwai@suse.de>
Date: Fri, 18 Jun 2010 17:25:20 +0200
Message-ID: <AANLkTim0i6BRZU1TxATJ9oeZjyEjzTwkzqr35D7_GU-z@mail.gmail.com>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
From: Miro Moman <miromoman@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Thanks for the advice. However, I have just built 2.6.35-rc3 and it
did not help at all.

Linux solaina 2.6.35-rc3-core2 #1 SMP PREEMPT Fri Jun 18 15:33:37 CEST
2010 x86_64 GNU/Linux



On Fri, Jun 18, 2010 at 2:11 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 17 Jun 2010 20:17:50 +0000 (UTC),
> Mirix wrote:
>>
>> Hello,
>>
>> I have a similar problem with hda-intel ALC883 since kernel 2.6.33 (problems are
>> identical with kernel 2.6.34). There are quick short gaps with the default
>> options. In turn, bdl_pos_adj=0 results in fast sound as reported here.
>> position_fix=1 does not fix it.
>>
>> The card worked fine with previous kernels.
>
> How about 2.6.35-rc3?  Another adjustment mechanism was introduced
> in 2.6.35, so this might work better...
>
>
> Takashi
>



-- 
http://www.edelmiromoman.eu/
