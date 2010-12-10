Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab0LJBIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:08:45 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:42390 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab0LJBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bGWuynuIdQ+cnG+Q84ooya7a00rS5sgDJxDwxWhWeP5QxYC1ul/SZyPFnUvwnXYFO8
         nD6V4ggGykxJFTuSQbE+I91tiyKm2FDnl9rlOCB9KUzq7Us0cu9Y/G5e+ovw3VQWKr59
         WJlTz27xY1CRdV+fLZJa3tvxwGtnJm4x0IIWI=
MIME-Version: 1.0
In-Reply-To: <AANLkTim5HQGNL-vSapeQw_-dJue89pYz7zc8eiShma8j@mail.gmail.com>
References: <AANLkTim5HQGNL-vSapeQw_-dJue89pYz7zc8eiShma8j@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Dec 2010 17:08:22 -0800
Message-ID: <AANLkTikFnb=ErjA0VeS6oekExHxT1-Mh5_wa28UqEZZ4@mail.gmail.com>
Subject: Re: compat-wireless-2.6.37-rc5 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 4:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> In later releases we will have to consider if we want to cherry pick
> anything extra or leave them as is. These few patches seem tempting to
> suck in:
>
> 01-ath9k-OTP.patch
> 03-ath9k-no-aggr-VO.patch
> 04-mac80211-no-aggr-VO.patch
> 05-ath9k-Reintroduce-modparam-to-enable-btcoex.patch
> 06-ath9k_hw-fix-A-MPDU-key-search-issues-on-AR9003.patch
>
> Particularly it is now known AR9003 devices will only ship with OTP
> so..

So it turns out this is inaccurate, AR9003 devices can ship with
EEPROM only or with OTP, it will vary, so while 2.6.36 and 2.6.37 will
not support only OTP based devices 2.6.38 will support both. What we
can do is cherry pick the OTP patches to the 2.6.36 and 2.6.37
compat-wireless releases but those two older stock kernels won't have
support for these.

 Luis
