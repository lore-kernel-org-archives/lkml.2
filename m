Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2DCG0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:26:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33974 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DCG0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <4F7A923D.5000002@candelatech.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
Date: Tue, 3 Apr 2012 11:56:12 +0530
Message-ID: <CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kelly,

please provide us as much details, about the card and pls provide
lspci -vvvvvvxxx output to see if the ASPM is enabled or not. cced
Felix also

PS: Ben thanks!

On Tue, Apr 3, 2012 at 11:31 AM, Ben Greear <greearb@candelatech.com> wrote:
> Ath9k list should be interested in this...
>
> Ben
>
> On 04/02/2012 10:46 PM, Kelly Anderson wrote:
>> This patch in 3.3.1 is causing ath9k device not to show/work on bootup.
>> ifconfig does not show the device unless I revert this patch. With the patch
>> reverted the device works as expected. This is verified on two different
>> machines that are both using ath9k mini-pcie wifi cards.
>>
>>>> ath9k: fix going to full-sleep on PS idle
>>
>>>> commit c1afdaff90538ef085b756454f12b29575411214 upstream.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel



-- 
thanks,
shafi
