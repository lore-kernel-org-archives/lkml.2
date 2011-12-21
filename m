Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1LUKr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:47:26 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2774 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1LUKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:47:24 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EF1B92D.9040405@broadcom.com>
Date: Wed, 21 Dec 2011 11:47:09 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 tree
References: <20111221124931.992e4e4265f2c3cd1d2e75b4@canb.auug.org.au>
In-Reply-To: <20111221124931.992e4e4265f2c3cd1d2e75b4@canb.auug.org.au>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62EF649E3GG11619515-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 02:49 AM, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c between commit
> 3db1cd5c05f3 ("net: fix assignment of 0/1 to bool variables") from the
> tree and commit 3fb1d8d2dad3 ("brcm80211: fmac: move driver up status to
> struct brcmf_bus") from the wireless-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 

Thanks, Stephen

I noticed Rusty's patch and the use of 0/1 for bool in our tree. Was
going to fix that, but this fix looks fine.

Gr. AvS

