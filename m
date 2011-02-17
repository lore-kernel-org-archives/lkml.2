Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1BQRGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:06:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55439 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1BQRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=cmcGUbsgTTdrEiKebG/Z5DZTYQrfp5EgDoS1I3EwmuNc8NsqWewoFchIaXhEhDIWmj
         YDoA+MLICSpSICkF3nl6KrT5mmOE40SKt5QBYtelqhMa7xdxmYqVudyv/uCRzopgt9JS
         9QdSV9Too3vAtW3j6A85ld4zDSLVzV7vZXvkw=
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <2CAEA7E9-A79D-473F-9298-15CB464BBBFB@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <alpine.LNX.2.00.1102171742190.2160@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH]drivers:scsi Change initate to initiate.
Date: Thu, 17 Feb 2011 09:06:32 -0800
References: <1296244148-3808-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1102171742190.2160@pobox.suse.cz>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 17, 2011, at 8:42 AM, Jiri Kosina wrote:

> On Fri, 28 Jan 2011, Justin P. Mattock wrote:
>
>> Not sure if this is a typo or not. if it is then feel free to take  
>> this.
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>
>> ---
>> drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
>> drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
>> 2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ 
>> ql4_isr.c
>> index 6ffbe97..03e028e 100644
>> --- a/drivers/scsi/qla4xxx/ql4_isr.c
>> +++ b/drivers/scsi/qla4xxx/ql4_isr.c
>> @@ -1027,7 +1027,7 @@ void qla4xxx_process_aen(struct scsi_qla_host  
>> * ha, uint8_t process_aen)
>> 					((ddb_entry->default_time2wait +
>> 					  4) * HZ);
>>
>> -				DEBUG2(printk("scsi%ld: ddb [%d] initate"
>> +				DEBUG2(printk("scsi%ld: ddb [%d] initiate"
>> 					      " RELOGIN after %d seconds\n",
>> 					      ha->host_no,
>> 					      ddb_entry->fw_ddb_index,
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ 
>> ql4_os.c
>> index 3fc1d25..967836e 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -812,7 +812,7 @@ static void qla4xxx_timer(struct scsi_qla_host  
>> *ha)
>> 					);
>> 				start_dpc++;
>> 				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
>> -					     "initate relogin after"
>> +					     "initiate relogin after"
>> 					     " %d seconds\n",
>> 					     ha->host_no, ddb_entry->bus,
>> 					     ddb_entry->target,
>
> As it's not in linux-next as of today, I'll be picking it up.
>
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.


alright... if I run into anymore small typos like this Ill send them  
on up!!

Justin P. Mattock
