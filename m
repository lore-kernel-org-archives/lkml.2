Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1ATFbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:31:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41336 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1ATFbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dtkZcDGxfNsDz0DibuDmg1m0U44rM/qNlh6Dm5Jaz4eYmZtu/JlGuGFs3nA/CYFYI1
         8uxlY4I9ZW4IWGvNAzTUWvlmm6OtqqaR2RCOXOQUC0wAyyxwiMTxDLuJvl+ufZ1kHB4i
         d0+g9WZXM2b9FTkn9L4fBPEndP+5L1uecxtuI=
MIME-Version: 1.0
In-Reply-To: <1295455290.1952.22.camel@Joe-Laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295284788.21277.65.camel@Joe-Laptop> <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
 <1295455290.1952.22.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 20 Jan 2011 13:30:57 +0800
Message-ID: <AANLkTi=NU=ANUDGGdiCL+AP696nF1kXwPHOPZPrCti2u@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com,
        eric.dumazet@gmail.com, dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Thu, Jan 20, 2011 at 12:41 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-01-19 at 17:40 +0800, Po-Yu Chuang wrote:
>> Well, TBH, I don't like this style because if I changed the
>> function name, the indentation might need to be adjusted.
>
> No worries.  That could happen using either style.
>
> There's no required style so you can use what you are
> most comfortable doing.  It's not a big deal at all.
>
>> Even worse, I got an infeasible case :-(
>>
>> static struct ftmac100_rxdes *ftmac100_rx_locate_first_segment(
>>                                                              struct ftmac100 *priv)
>>
>> I know my function names are quite long, but I like them to be descriptive.
>> Do you really insist on it?
>
> Here's a common alternative style for this case:
>
> static struct ftmac100_rxdes *
> ftmac100_rx_locate_first_segment(struct ftmac100 *priv)

OK, I see.

One more question: how to deal with this? Add a local variable for the
2nd argument?

	ftmac100_set_receive_ring_base(priv,
				       priv->descs_dma_addr + offsetof(struct ftmac100_descs, rxdes));

best regards,
Po-Yu Chuang
