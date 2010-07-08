Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0GHVYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:24:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54372 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0GHVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EU3S37I1F+N+oxbno8MmXLxaKwfrPiQ1fInjZ5mjKLYCBR9e1RetoysUrQ3drFvgN8
         4TClp2PtRy/YUbqmooU/hPCAYimR5n4qT1m+xTeufM+z712rB64jHFwq8hllZs9N5l0f
         jc5CUtrOwsbjQocIZFtoYgGBuPdyihjg5na5c=
Message-ID: <4C36423A.8040201@gmail.com>
Date: Thu, 08 Jul 2010 14:25:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth@vger.kernel.org, gustavo@padovan.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8 v2]Bluetooth: Fix warning: variable 'tty' set but
 not used
References: <1276565200-5583-1-git-send-email-justinmattock@gmail.com> <1278623228.10421.70.camel@localhost.localdomain>
In-Reply-To: <1278623228.10421.70.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 02:07 PM, Marcel Holtmann wrote:
> Hi Justin,
>
>> Resend of this patch to fix whitespace issues
>> The patch below fixes a warning message
>> when using gcc 4.6.0
>>
>>    CC [M]  drivers/bluetooth/hci_ldisc.o
>> drivers/bluetooth/hci_ldisc.c: In function 'hci_uart_send_frame':
>> drivers/bluetooth/hci_ldisc.c:213:21: warning: variable 'tty' set but not used
>>
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>   Reviewed-By: Gustavo F. Padovan<gustavo@padovan.org>
>
> patch has been applied to bluetooth-next-2.6 tree. Thanks.
>
> Regards
>
> Marcel
>
>
>


cool..

Justin P. Mattock
