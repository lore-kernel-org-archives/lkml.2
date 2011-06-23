Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583Ab1FWX5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:57:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55705 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab1FWX5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BijtZU2ZRbgSTkTDqqPNyvhfte7GscYkhCWloh52rvIHkEDmBy+eanR43AQQ+am4ad
         nRT3ir9Jyc3LGC4tv03y/FWZhikrcBrDVpPjEeGSVtjstlg3/PRo8U2WcaDIclHYNcDH
         gSWSslSTUgIZgIef3N1q5mftH7ZvXIp53yIrg=
Message-ID: <4E03D2D0.2030300@lwfinger.net>
Date: Thu, 23 Jun 2011 18:57:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andre Nogueira <andre.neo.net@gmail.com>, devel@driverdev.osuosl.org,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Mike McCormack <mikem@ring3k.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Julia Lawall <julia@diku.dk>,
        Joe Perches <joe@perches.com>, David Chosrova <dada2372@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: Re: [PATCH 19/37] Remove unneeded version.h includes from drivers/staging/rtl*/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240036380.17688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106240036380.17688@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 05:40 PM, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/staging/rtl8187se/,
> drivers/staging/rtl8192e/, drivers/staging/rtl8192u/&
> drivers/staging/rtl8712/.
> This patch removes them.
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 -
>   .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    1 -
>   .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    1 -
>   .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |    1 -
>   .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    1 -
>   .../staging/rtl8187se/ieee80211/ieee80211_module.c |    1 -
>   .../rtl8187se/ieee80211/ieee80211_softmac.c        |    1 -
>   drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    1 -
>   .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |    1 -
>   .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
>   .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |    1 -
>   .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |    1 -
>   .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    1 -
>   drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    1 -
>   .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    1 -
>   drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    1 -
>   drivers/staging/rtl8192e/r8192E.h                  |    1 -
>   drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    1 -
>   .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |    1 -
>   .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
>   .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    1 -
>   .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    1 -
>   .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    1 -
>   drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    1 -
>   .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    1 -
>   drivers/staging/rtl8192u/r8192U.h                  |    1 -
>   drivers/staging/rtl8712/osdep_service.h            |    2 --
>   27 files changed, 0 insertions(+), 28 deletions(-)

ACK for rtl8187se and rtl8712 (r8712u).

Larry Finger

