Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab2FFXno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:43:44 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2379 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2FFXnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:43:42 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4FCFEB0E.2020206@broadcom.com>
Date: Wed, 6 Jun 2012 16:43:10 -0700
From: "Franky Lin" <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Julia Lawall" <Julia.Lawall@lip6.fr>
cc: "Brett Rudley" <brudley@broadcom.com>, kernel-janitors@vger.kernel.org,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Arend van Spriel" <arend@broadcom.com>,
        "Kan Yan" <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 5/7]
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c: adjust suspicious bit
 operation
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
 <1339018901-28439-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1339018901-28439-6-git-send-email-Julia.Lawall@lip6.fr>
X-WSS-ID: 63D134D83E043679879-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 02:41 PM, Julia Lawall wrote:
> From: Julia Lawall<Julia.Lawall@lip6.fr>
>
> IRQF_TRIGGER_HIGH is 0x00000004, so it seems that&  was intended rather than |.
>
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
>
> Signed-off-by: Julia Lawall<julia@diku.dk>

Thanks, Julia. But this has already been fixed by Joe Perches [1] and 
the patch has arrived at Linux wireless tree.

Franky

[1] https://lkml.org/lkml/2012/5/30/482

