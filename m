Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1LHHFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:05:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43282 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1LHHFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:05:37 -0500
MIME-Version: 1.0
In-Reply-To: <20192.24749.652755.425707@ipc1.ka-ro>
References: <cover.1323256319.git.LW@KARO-electronics.de>
	<20111207.133800.1403774147364781100.davem@davemloft.net>
	<20192.24749.652755.425707@ipc1.ka-ro>
Date: Thu, 8 Dec 2011 15:05:36 +0800
Message-ID: <CAAQ0ZWRXu+2h2Qu6pe12e=SsSrt-UxvdtfF7httbAdw8sOUY_A@mail.gmail.com>
Subject: Re: [PATCH v2 0/8][NET] fec.c: several cleanups and bugfixes
From: Shawn Guo <shawn.guo@linaro.org>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2011 15:01, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> Hi,
>
> David Miller writes:
>> From: Lothar Waﬂmann <LW@KARO-electronics.de>
>> Date: Wed, †7 Dec 2011 14:37:12 +0100
>>
>> > The following set of patches provides some cleanup and bugfixes for
>> > drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
>> > a module.
>>
>> 1) I said to use a subject prefix of "fec: " not "fec.c: "
>>
> OK.

To be consistent with existing commits, I would suggest use "net/fec:
" as the subject prefix.

>
>> 2) You did not integrate Shawn's "Acked-by: " tags, I'm not going to
>> † †go sifting through the previous patch postings to collect them up,
>> † †that's your job.
>>
> I still got no Ack from Shawn for patches 3 and 5 and only Tested-by
> for patches 6 thru 8. Should I wait for Shawn's Ack for those patches
> too, or should I resent now?
>
For the whole series,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn
