Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0K3Tal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:30:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54553 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0K3Tak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=xtGdxSJB/2g+pFCt0nDKWnSahEfN/v1t9mNqmgwLYBUTYxPfInQosyzX9W/jSWtMpR
         +bb2bSA/tlxTttyPtFUVqB61KHHgnwcNxTa8Y+ueOrfkSB/oJwcgKRAgN9dVnS3lFFoo
         L1b0G1ovkmRV4WqPjLTG+/0tYGoAEaaYxcOhM=
MIME-Version: 1.0
In-Reply-To: <20101130192648.GA1623@ucw.cz>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <20101118113441.74fcdc21@lxorguk.ukuu.org.uk> <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
 <20101130192648.GA1623@ucw.cz>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 30 Nov 2010 11:30:18 -0800
X-Google-Sender-Auth: DcHSiAXThOacz6NMTHRptcKF9Bc
Message-ID: <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Pavel Machek <pavel@ucw.cz>, bkuhn@ebb.org
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

On Tue, Nov 30, 2010 at 11:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> everything else can be independent code. For ath9k in particular this
>> >> means we keep ath9k_hw shared between our Operating Systems and that's
>> >> it. In addition to this I believe opening up the common drivers for
>> >
>> > The Linux copy needs to be GPL,
>>
>> GPL-Compatible you mean, right. I mean we have ath9k_hw with
>> permissive licensed files.
>
> GPL-compatible is not right word. It has to be either GPL, or so
> permissive that anyone is allowed to turn it into GPL.

Oh?

  Luis
