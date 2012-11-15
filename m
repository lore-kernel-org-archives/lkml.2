Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992918Ab2KOIHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:07:17 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3881 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992679Ab2KOIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:07:16 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50A4A290.3070707@broadcom.com>
Date: Thu, 15 Nov 2012 09:06:40 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
References: <20121115131707.25e7df1ab635c18e62f0712a@canb.auug.org.au>
In-Reply-To: <20121115131707.25e7df1ab635c18e62f0712a@canb.auug.org.au>
X-WSS-ID: 7CBA7D8C3R02744145-19-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 03:17 AM, Stephen Rothwell wrote:
> Hi John,
>
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c between commit
> d61f978b8f26 ("brcmfmac: fix typo in CONFIG_BRCMISCAN") from the  tree
> and commit f07998959d57 ("brcmfmac: remove obsolete i-scan and clean up
> related code") from the wireless-next tree.
>
> I used the latter (which removed the line that was fixed in the former)
> and can carry the fix as necessary (no action is required).
>

Agreed. The typo fix is only needed for v3.7.

Gr. AvS

