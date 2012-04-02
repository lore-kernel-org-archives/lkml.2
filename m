Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2DBPa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:30:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60982 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DBPaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
References: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
	<CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
Date: Mon, 2 Apr 2012 21:00:24 +0530
Message-ID: <CAFPAmTSpi1nf6goe12=nM4JOCgk3XpEYB3WNaPQ582pQZdknwA@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Looks very good, thanks.
>
>> @@ -122,6 +124,7 @@ good_area:
>>                if (!(vma->vm_flags & VM_WRITE))
>>                        goto bad_area;
>>                writeaccess = 1;
>> +               flags |= FAULT_FLAG_WRITE;
>
> Could you remove the 'writeaccess' variable as well? It looks unused
> after applying your patch.

Sure, Ill do that and send v2.1 of this patch to you.

>
> Ug...the avr32 arch is in a terrible state. Someone appears to have
> removed the atmel_nand driver...

I don't know anything about that. :)

>
> Havard
