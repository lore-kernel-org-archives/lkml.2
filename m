Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0JQVnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:43:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38456 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0JQVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ty3krICH394dUoToN6RkVqUijVl5mc9h3admHjuq5bKK94PBzswmyxpCraEbwB/Nxj
         zD8sUxnoGI+rfD8ejRUflqPxEup98PrLg85sOEy2a2ZhEvfCdMsUp3UBjB3RK+nTdJ9s
         wFJ5Ug1mQ2BXD6L1zseM/Rx4duUsNFxu3yIHY=
Message-ID: <4CBB6E29.9090808@gmail.com>
Date: Sun, 17 Oct 2010 14:44:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
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
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <7N-qxsaxKCN.A.YpC.ok1uMB@chimera>
In-Reply-To: <7N-qxsaxKCN.A.YpC.ok1uMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2010 01:21 PM, Rafael J. Wysocki wrote:
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
> Date		: 2010-09-28 22:30 (20 days old)
> Message-ID	:<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
>
>


yeah it's still here...(I can try and play with this, but who knows..)

Justin P. Mattock
