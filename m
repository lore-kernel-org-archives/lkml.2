Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2HIJqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:46:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62178 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab2HIJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:46:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAB=NE6UP7JfP+Uxo1Px67-xsGrsfddyyqTVP=ybbZCnE=2kxFw@mail.gmail.com>
References: <CAB=NE6WZWEO=b5Usx4RKDLC--TvLWnOom0P+HmXsxh7QZQQXQA@mail.gmail.com>
	<CAFub=KRtuTDn1DnHP0aKZT6RBeA2kNkLm6ud-4Z=1ESPs==h0g@mail.gmail.com>
	<CAB=NE6V7Tx1ioDafPmOprwzd0Q61dDe8XK5gBghXHVROXOBA=Q@mail.gmail.com>
	<CA+icZUV51Bk=jxnfrGL4xo6MQXnVdhUCago_RPZM-iL+twpF1A@mail.gmail.com>
	<CAB=NE6UP7JfP+Uxo1Px67-xsGrsfddyyqTVP=ybbZCnE=2kxFw@mail.gmail.com>
Date: Thu, 9 Aug 2012 11:46:48 +0200
Message-ID: <CA+icZUXsaB8nu7ag5=sSsEDJU49x-4eSVQH0U4=J9G71fAmOYA@mail.gmail.com>
Subject: Re: Using vanilla kernels headers to do backport testing -- issues
 with memcpy()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 11:01 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Thu, Aug 9, 2012 at 12:27 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> I am not an English native but this sentence sounds a bit strange to
>> me ("used" followed by "require" and double "Linux"?).
>> I can imagine what you want to express but have no better wording right now.
>>
>> 180 +  echo -e "   This was added since kernels >= 3.4 used require"
>> 181 +  echo -e "   a glibc >= 2.14 for memcpy(), and not all Linux"
>> 182 +  echo -e "   Linux distributions have such glibc.
>
> Fixed.
>

Thanks for the quick fix, sounds much better now.

- Sedat -

>  Luis
