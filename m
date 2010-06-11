Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab0FKLrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:47:12 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45125 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0FKLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZNlAde/JZm9i+CvU3asSBIhGs80epFyNRKP+SUs9BneVkjBUewvfYG8beinb0YP1S6
         Td2INLet2MWcNbv68gmxSwhqAeC8qhskb5TLlfuL8NI4JkkAZup5gtvdX+m6VgRvKYBd
         4OaY2hV6BEiLywMJpnzEY1aOtr+OLLnEfXYVA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinfoyhEyFjxReR6Oza7r_AQhcyMlpaXYB4ZjjlU@mail.gmail.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	<1274726029.2091.15160.camel@rchatre-DESK>
	<1274738896.2091.15438.camel@rchatre-DESK>
	<1274830187.2091.17034.camel@rchatre-DESK>
	<1275600737.2091.32332.camel@rchatre-DESK>
	<AANLkTinfoyhEyFjxReR6Oza7r_AQhcyMlpaXYB4ZjjlU@mail.gmail.com>
Date: Fri, 11 Jun 2010 17:09:17 +0530
Message-ID: <AANLkTillaEGISTjW4iqpsNsJbaE6ZW7pqYvAzoBrkI69@mail.gmail.com>
Subject: Re: iwl3945 bug in 2.6.34
From: Satish Eerpini <eerpini@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.34 vanilla kernel with the above patches applied crashed again
today, I was amidst a conference on webex when this happened, still
not able to figure out what is the kind of traffic that causes the
driver to give up ... here is output from dmesg :


cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: IN
cfg80211: Regulatory domain changed to country: IN
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5250000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 2000 mBm)
wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
wlan0: authenticated
wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 4-2: USB disconnect, address 4
iwl3945 0000:10:00.0: queue 2 stuck 3 time. Fw reload.
iwl3945 0000:10:00.0: On demand firmware reload
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: BSM uCode verification failed at addr
0x00003800+0 (of 900), is 0xffffffff, s/b 0xf802020
iwl3945 0000:10:00.0: Wait for START_ALIVE timeout after 2000ms.
No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: IN
cfg80211: Regulatory domain changed to country: IN
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5250000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 2000 mBm)

is there anything else that can be done ??

Cheers
Satish

On Fri, Jun 11, 2010 at 12:19 AM, Satish Eerpini <eerpini@gmail.com> wrote:
> I have applied the patches to the 2.6.34 kernel, my machine has been
> up for 20 hours now, there is nothing in the dmesg either, dmesg |
> grep wlan0 just gives this :
>
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
> wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: no IPv6 routers present
> wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
> wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: no IPv6 routers present
> wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
> wlan0: associated
> wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
> wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
> wlan0: associated
>
> so I think after applying the patches, things have been working fine.
>
> Cheers
> Satish
>
> --
> http://satisheerpini.net
>



-- 
http://satisheerpini.net
