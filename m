Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0ISPDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:03:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51492 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0ISPDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=snxPBjf5hL/KYTeq7KxPlFzg7rv2S6bS1wSZEzahJi9LTx7l14+1J+OLf1DGHTZ4gL
         0v6ZEirktyY8eVhHqSxCv00jk5wQyzMJ9AnjxY+G8K9drL/Wm8OUerr1PY+XHPGqj+Q3
         SUj/z/Ew+MoEewzJ/5+sSeKmhL4T0+WfTS79Y=
MIME-Version: 1.0
In-Reply-To: <4C95D82F.2080001@kernel.org>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi==_Tvt6hosvfKDdd9uivsa5SVPiqSHNg5Ob3-v@mail.gmail.com>
 <1284886192.1778.94.camel@Joe-Laptop> <4C95D82F.2080001@kernel.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 19 Sep 2010 08:03:24 -0700
Message-ID: <AANLkTikzw7-vwsP+cJHb1AXaiih=Zhx6r9NJVK39OgFG@mail.gmail.com>
Subject: Re: [PATCH v2] scripts: add typdef removal tool
To: Pekka Enberg <penberg@kernel.org>, Greg KH <greg@kroah.com>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Julia Lawall <julia@diku.dk>, Nicolas Palix <npalix@diku.dk>,
        Yoann Padioleau <yoann.padioleau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 2:30 AM, Pekka Enberg <penberg@kernel.org> wrote:
>  On 19.9.2010 11.49, Joe Perches wrote:
>>
>> On Sun, 2010-09-19 at 11:19 +0300, Pekka Enberg wrote:
>>>
>>> On Fri, Aug 14, 2009 at 8:39 AM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com>  wrote:
>>>>
>>>> If you are porting drivers and need to remove tydpefs you can use
>>>> this to help you port the driver faster. Until we don't have a fully
>>>> correct and complete way to do this through Coccinelle spatch we
>>>> might as well help developers porting drivers with something. spatch
>>>> also has a learning curve, people working on staging may not end
>>>> up using it for a while.
>>>
>>> How come this script never made it to the kernel tree?
>>
>> General lack of interest?
>>
>> Probably the same reason that similar patches didn't.
>> https://patchwork.kernel.org/patch/88026/
>
> Scripts like these are sure handy when dealing with the crap in staging
> tree.

Or if you are trying to avoid staging by doing all the hard work yourself.

> Maybe we can convince Greg to take them in.

:)

  Luis
