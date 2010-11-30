Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0K3TmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:42:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36176 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0K3TmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:42:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=KuKy8WfHlcz1CUAyXRF6nD9s7jh9LQt0UYBLknynaVqlCadGa1+qM3PMp5WumBqCew
         RAI10C6vsb0wyxHOIlsYOC5j7dg0FCvQrgasHnArNs1icvus4vtHkCQ7mF66+ho0Y2yr
         iyG3njnhHPX1MGTiAhI9LL9ykAq2g4yej871U=
MIME-Version: 1.0
In-Reply-To: <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <20101118113441.74fcdc21@lxorguk.ukuu.org.uk> <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
 <20101130192648.GA1623@ucw.cz> <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 30 Nov 2010 11:41:47 -0800
X-Google-Sender-Auth: RB27RnMwQfJ_xauh0uiLNpVCsuw
Message-ID: <AANLkTimRshCxrBUB9z+zMSHdsELEquMRVcvaKFRiLMTc@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Pavel Machek <pavel@ucw.cz>, bkuhn@ebb.org,
        David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:30 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Nov 30, 2010 at 11:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>>> >> everything else can be independent code. For ath9k in particular this
>>> >> means we keep ath9k_hw shared between our Operating Systems and that's
>>> >> it. In addition to this I believe opening up the common drivers for
>>> >
>>> > The Linux copy needs to be GPL,
>>>
>>> GPL-Compatible you mean, right. I mean we have ath9k_hw with
>>> permissive licensed files.
>>
>> GPL-compatible is not right word. It has to be either GPL, or so
>> permissive that anyone is allowed to turn it into GPL.
>
> Oh?

I actually was just thinking of getting rid of all the silly
MODULE_LICENSE() crap we have that is for GPL-Compatible licenses and
just adding:

MODULE_LICENSE("GPL-Compatible");

and be done with it. All the other stuff just confuses people.

  Luis
