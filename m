Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1AUDgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:36:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1AUDf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DjfK85aqx8m8niee3mJyQQrIFWKJriVmevuZeQGlXNRE3gt+mf2/6UiFjkOCqgcycR
         8TTxR2W3FYBas9QQ7pM7wVSxxsTW1aK41KhD6WKaADjoZOxEoxOUWETXbsagJh4E+fsO
         Vcb1CFUrxmvr+DgdWYpNCp97iwKrpP670OcC0=
MIME-Version: 1.0
In-Reply-To: <1295546179.28001.4.camel@Joe-Laptop>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com> <1295546179.28001.4.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 21 Jan 2011 11:35:37 +0800
Message-ID: <AANLkTik-d86O8EHZctzuy7=CGgTkSaD4m9Lcqh_wofEL@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Fri, Jan 21, 2011 at 1:56 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-01-20 at 23:30 +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> []
>> +     /* map io memory */
>> +     priv->res = request_mem_region(res->start, res->end - res->start,
>> +                                    dev_name(&pdev->dev));
>
> Off by one?
>
>        priv->res = request_mem_region(res->start, resource_size(res),
>                                       dev_name(&pdev->dev));

Fixed.

best regards,
Po-Yu Chuang
