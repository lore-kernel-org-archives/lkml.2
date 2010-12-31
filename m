Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab0LaGzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 01:55:04 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:52337 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0LaGzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 01:55:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=nIs+bj2GfbST36LmRPdRZ28QP6cjqzqno1d4eSSmJg37UUxU9KmrnZef/LiTSjTM4A
         jHrXWNSn+kL6Pcv0io0MPm9eo1989p6G8tyNtpg1rUfHXLlqzKFndgA+qZzkyiwtQxp4
         UtVahVD2PVkIjPMqmrvZo8RXaXbCdydRvjBio=
Message-ID: <4D1D7A74.3030803@gmail.com>
Date: Thu, 30 Dec 2010 22:38:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 15/15]drivers:spi:dw_spi.c Typo change diable to disable.
References: <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com> <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com> <1293750484-1161-15-git-send-email-justinmattock@gmail.com> <20101231063433.GB1886@bicker>
In-Reply-To: <20101231063433.GB1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 10:34 PM, Dan Carpenter wrote:
> On Thu, Dec 30, 2010 at 03:08:04PM -0800, Justin P. Mattock wrote:
>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>> is correct or not.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/spi/dw_spi.c |    6 +++---
>
> You missed one from this file:
>
> /* Set the interrupt mask, for poll mode just diable all int */
>                                                ^^^^^^
> regards,
> dan carpenter
>
>

oh-man... my grepping wasn't so grepping after all.. thanks for that 
I'll resend this one

Justin P. Mattock
