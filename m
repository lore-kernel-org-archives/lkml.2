Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0EQHrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:47:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0EQHrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tUBy36+KX32mKYYxe7aO9w3ln3Vp38l1WhWE4uBQA6s/EAjvDaL2E0DIOKI9AyopwP
         ssIhabBG8etKUeLZc5R6jGt/YPhFePOBC76G8fZ7LQ5SCoTig37rjnS5XWrgAEZFS/gP
         YOePOV8rD1IDgvzOu+ybqdJg1Q/FpaTbwfRJs=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005152314540.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152314540.21345@ask.diku.dk>
Date: Mon, 17 May 2010 10:47:17 +0300
X-Google-Sender-Auth: RUmCQ5X7c2M1F7SrG1VL2mJlv0w
Message-ID: <AANLkTimPDHCFcMruCqNUZKsbvKuszh5gWA052SgaPTkD@mail.gmail.com>
Subject: Re: [PATCH 7/37] drivers/net/wireless/wl12xx: Use kmemdup
From: Kalle Valo <kvalo@adurom.com>
To: Julia Lawall <julia@diku.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2010 00:15, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.

Thanks, looks good to me.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Kalle Valo <kvalo@adurom.com>
