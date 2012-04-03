Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2DCGBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:01:46 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48794 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2DCGBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:01:45 -0400
Message-ID: <4F7A923D.5000002@candelatech.com>
Date: Mon, 02 Apr 2012 23:01:33 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kelly Anderson <kelly@silka.with-linux.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: 3.3.1 ath9k regression
References: <4F7A8EB7.4060200@silka.with-linux.com>
In-Reply-To: <4F7A8EB7.4060200@silka.with-linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ath9k list should be interested in this...

Ben

On 04/02/2012 10:46 PM, Kelly Anderson wrote:
> This patch in 3.3.1 is causing ath9k device not to show/work on bootup.
> ifconfig does not show the device unless I revert this patch. With the patch
> reverted the device works as expected. This is verified on two different
> machines that are both using ath9k mini-pcie wifi cards.
>
>>> ath9k: fix going to full-sleep on PS idle
>
>>> commit c1afdaff90538ef085b756454f12b29575411214 upstream.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
