Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0JJTTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:19:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45193 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0JJTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EaSlGagn4fVTg4XVLAFESUK0S1gIcSEwgflC32u6CGd0olsMZZzPwL+PG+fmQ+8Fce
         aTmB6+OhFLA4uJQTR3KvCaoG/xn/IKwyEmzhJ5k10KppcxAJ/hCtZAKNbdxyh/JENkCQ
         9yiiOUZR+ThfxHY2r8m9ltBynfazBGjLTs18k=
Message-ID: <4CB211C7.20809@gmail.com>
Date: Sun, 10 Oct 2010 12:19:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475
 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
References: <v0Rsc8XZnFC.A.-xF.oqfsMB@chimera> <xpndfyzv9iD.A.STG.7qfsMB@chimera>
In-Reply-To: <xpndfyzv9iD.A.STG.7qfsMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/10/2010 10:51 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
> Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2010-09-28 22:30 (13 days old)
> Message-ID	:<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
>
>
as far as I know this is still here.. I can pull the latest to see
if it's been fixed, as well as the wireless tree to see.

Justin P. Mattock
