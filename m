Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1C3B5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1C3B5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:57:07 -0400
Message-ID: <4D928DE2.8070804@redhat.com>
Date: Tue, 29 Mar 2011 22:56:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: [PATCH -next] staging: altera-jtag needs delay.h
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>	<20110304173528.60c04f76.randy.dunlap@oracle.com> <AANLkTinhKKtPS7-tFcoU8JE=zsgikEn979DemyXX8q_z@mail.gmail.com>
In-Reply-To: <AANLkTinhKKtPS7-tFcoU8JE=zsgikEn979DemyXX8q_z@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-03-2011 18:27, Alexander Beregalov escreveu:
> On 5 March 2011 04:35, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> altera-jtag.c needs to include <linux/delay.h> to fix a build error:
>>
>> drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Igor M. Liplianin <liplianin@netup.ru>
> 
> Mauro, Greg. 2.6.39 still needs this fix.

I'm updating the fix right now to -next. I'll be sending it upstream after having it
merged there.

Thanks,
Mauro.
