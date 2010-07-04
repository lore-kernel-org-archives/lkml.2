Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0GDPzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:55:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51752 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0GDPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VYrB9R40UyNkt9RRbxQ9uI4pLcdvm+6tzOn/3HJYnLZOWoMfbsBcaahJIMPKjr36Az
         0f2ePdtg+Ph9T4AXeu4Wt1dsfoxJtEtfIb3zI9zIcARhZ8Leg2ThgykAyiWIQzc9Qz1b
         QyiTTPkganMA+Cv0dWNos4lhmg+vZV0yDlpsY=
MIME-Version: 1.0
In-Reply-To: <AANLkTilxNz_iEWKtgvLHjce6PTN_G-7bt2jxeLbIXxVa@mail.gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de> <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de> 
	<AANLkTimVRdxeeQKazgFSIQJYtbmHnjDN5lUnTrVv6uoI@mail.gmail.com> 
	<20100701132351.GB32541@faui48a.informatik.uni-erlangen.de> 
	<AANLkTilxNz_iEWKtgvLHjce6PTN_G-7bt2jxeLbIXxVa@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 4 Jul 2010 23:55:30 +0800
Message-ID: <AANLkTinW0rb1E0lq5tqBNc7gR9zCyfRJoIRnsLemcVMB@mail.gmail.com>
Subject: Re: [PATCH 06/33] Removing dead SHARPSL_LOCOMO
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 10:40 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 9:23 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> On Thu, Jul 01, 2010 at 10:34:13AM +0800, Eric Miao wrote:
>>> On Wed, Jun 30, 2010 at 11:55 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
>>> > SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
>>> > references for it from the source code.
>>> >
>>>
>>> A good catch, though SHARPSL_LOCOMO has be changed to SHARP_LOCOMO
>>> later, so a better fix would be the name change only.
>>
>> Hi! Updated patch below
>>
>> ----
>> From: Christoph Egger <siccegge@cs.fau.de>
>> Date: Wed, 30 Jun 2010 12:36:20 +0200
>> Subject: [PATCH 06/33] Replacing dead SHARPSL_LOCOMO with SHARP_LOCOMO
>>
>> SHARP_LOCOMO doesn't exist in Kconfig, therefore replacing all
>> references for it with SHARP_LOCOMO in the source code.
>>
>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>

Applied.
