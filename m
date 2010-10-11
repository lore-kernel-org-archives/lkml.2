Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0JKHIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:08:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59163 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0JKHIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qyz6N/QyVTX1BfQE9QgCRPFesF87Vp5+L+GiHn/OnQQS0FtA54VatBm5BRV7+RQ8tn
         PeUkzTOa8AMqMBQfIn+2vWFNwn0Wq6oELZqbT36YQX4T9odBVryx9ehGIBEYxK66wv2x
         DHKmuPwIdf2hOoyAUyGsWC+oTpCCIJZ8rcI/A=
MIME-Version: 1.0
In-Reply-To: <20101010095703.aeae2f15.rdunlap@xenotime.net>
References: <4CB1EBDD.8050509@gmail.com>
	<20101010095703.aeae2f15.rdunlap@xenotime.net>
Date: Mon, 11 Oct 2010 09:08:00 +0200
Message-ID: <AANLkTin1qUZ-Hp9J1HdzxHHf8uOY4_1Ss3wPDq35Z7F0@mail.gmail.com>
Subject: Re: [PATCH 15/16] pramfs: test module
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/10 Randy Dunlap <rdunlap@xenotime.net>:
> On Sun, 10 Oct 2010 18:37:49 +0200 Marco Stornelli wrote:
>
> Above 2 lines need to indented more.
>

Ack.

>> +             return 1;
>> +     }
>> +
>> +     /*
>> +      * Attempt an unprotected clear of checksum information in the
>> +      * superblock, this should cause a kernel page protection fault.
>> +      */
>> +     printk("%s: writing to kernel VA %p\n", __func__, psb);
>> +     psb->s_sum = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +void test_pramfs_write_cleanup(void) {}
>> +
>> +/* Module information */
>> +MODULE_LICENSE("GPL");
>> +module_init(test_pramfs_write);
>> +module_exit(test_pramfs_write_cleanup);
>
