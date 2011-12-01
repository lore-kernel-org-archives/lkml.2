Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1LATRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:17:38 -0500
Received: from mail2.unitix.de ([176.9.2.175]:49799 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab1LATRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:17:37 -0500
Message-ID: <4ED7D2CB.6010001@arndnet.de>
Date: Thu, 01 Dec 2011 20:17:31 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
References: <4EC6DE6B.3080603@arndnet.de> <4ECB65A5.3010009@arndnet.de> <CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com> <4ECD5CA7.4080606@arndnet.de> <CANUX_P29L-o8-KQ_G9i1b8NzJtHcmRBbDS_88-oKMVU_jiMY8Q@mail.gmail.com> <4ECEBD5A.9090307@arndnet.de> <CANUX_P3TMPeTJmcBbCe=97XMVw7=wAUymFv17W=YUAirgO8+uQ@mail.gmail.com>
In-Reply-To: <CANUX_P3TMPeTJmcBbCe=97XMVw7=wAUymFv17W=YUAirgO8+uQ@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.11.2011 10:50, schrieb Emmanuel Grumbach:
> On Thu, Nov 24, 2011 at 23:55, Arnd Hannemann <arnd@arndnet.de> wrote:
>> Hi,
>>
>> Am 24.11.2011 07:23, schrieb Emmanuel Grumbach:
>>>>
>>>> I applied the QUEUE_DEBUG.patch you posted in the other thread, not sure if I'm experiencing the same problem:
>>>
>>> Yes, it looks similar. Please enable the MAC80211_HT_DEBUG compilation flag too.
>>> In any case now that I more the less see what is happening, I am
>>> working now on another debug patch.
>>
...

> Sorry, somehow I saw the mail only now. This one should make it
> 
> http://www.spinics.net/lists/linux-wireless/msg81131.html

JFYI: I'm currently running on Linus git from Monday (last commit 4244cb482e8eab18142162a27c8829a04585863a)
for a while now and didn't have seen this Warning yet, nor did I experience the described lag.
Maybe some other patch might already have fixed it or at least lessen the probability for the
previous bug to occur.

Best regards
Arnd
