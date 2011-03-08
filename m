Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1CHSuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:50:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47711 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CHSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I/wUAICPlHKG98Fv7BdS2nyz7jsJ9V2rpXZ6M3ctRkI5lbqNdsvQDdp04AajR2Y/Jx
         QAneKnT0JxRdTEerriqRdgrunSynQlZw7Un5um4beU9Ycf+T7r9Qh4hdoIuO0qoz3Ja4
         NTvbl/NTo2XcxqJH9PQ3CWYvu3QORD4fTe1lA=
Message-ID: <4D767A4B.1060203@gmail.com>
Date: Tue, 08 Mar 2011 10:49:47 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@atheros.com
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda
 [ath9k]()
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>	<20110303135942.GA8969@tuxdriver.com>	<AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>	<20110307151201.GC2664@tuxdriver.com> <AANLkTi=7RSdKhzGazQFUnBZqzMQskOSHq=7E08uan2vu@mail.gmail.com>
In-Reply-To: <AANLkTi=7RSdKhzGazQFUnBZqzMQskOSHq=7E08uan2vu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 07:22 AM, Mohammed Shafi wrote:
> On Mon, Mar 7, 2011 at 8:42 PM, John W. Linville<linville@tuxdriver.com>  wrote:
>> On Sun, Mar 06, 2011 at 12:47:05AM -0800, Justin Mattock wrote:
>>
>>> full dmesg here:
>>> http://fpaste.org/5JQp/
>>> let me know if I need to supply any info(also I can try a bisect, but
>>> am in the middle of changing residencies, so it might not be right
>>> away)
>>
>> One of the Atheros guys suggested that you change a DMA timeout value.
>> Did you try that?
>
> John it looks like increasing the timeout also does not seems to help.
> A user reported this issue in ath9k developer list and he told that
> increasing the timeout did not fix this issue.
>
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

at barnes and noble, and I see this has fired off again. will see if I 
can reproduce and bisect.

full dmesg:

http://fpaste.org/6sIH/

Justin P. Mattock
