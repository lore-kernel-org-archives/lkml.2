Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0HHKgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 06:36:40 -0400
Received: from ns2.netcenter.hu ([195.228.155.139]:54297 "EHLO mail.1-click.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0HHKgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 06:36:37 -0400
Message-ID: <026c01cb361c$3c895b10$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <linux-kernel@vger.kernel.org>
References: <0f7601cb35be$d93998c0$0400a8c0@dcccs> <20100808174914A.fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi emulation - question
Date: Sat, 7 Aug 2010 12:35:14 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3664
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the tip.
I have not used this before.
But now i have readed the documentation, and for me it looks like scsi-debug 
can work only in RAM and can make only volatile drives.
Have i missed someting? :-)

Thanks,
Janos Haar

----- Original Message ----- 
From: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
To: <janos.haar@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>
Sent: Sunday, August 08, 2010 10:50 AM
Subject: Re: scsi emulation - question


> On Sat, 7 Aug 2010 01:26:45 +0200
> "Janos Haar" <janos.haar@netcenter.hu> wrote:
>
>> I am looking for a solution wich can emulate SCSI device from a block 
>> device
>> like loop.
>> I need the sg device but not for special commands, but for reading and
>> writing only.
>> I have found only one solution until now, but i want to find better and
>> faster.
>> The actually working is ISCSI target and initiator in one pc.
>> But this opens up port, and makes a lot of IP packets even if i use lo 
>> for
>> this, wich is only a waste of time and resources.
>
> scsi-debug should work for you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/ 

