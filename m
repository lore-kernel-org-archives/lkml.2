Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2CWPaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:30:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59246 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682Ab2CWPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:30:12 -0400
Message-ID: <4F6C9701.50103@pobox.com>
Date: Fri, 23 Mar 2012 11:30:09 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the scsi tree
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au> <1332478202.2882.2.camel@pasglop> <CACVxJT-MgLO5aLiRuSR=61nea47V27vsXJB9St20J6G6hSe8xw@mail.gmail.com>
In-Reply-To: <CACVxJT-MgLO5aLiRuSR=61nea47V27vsXJB9St20J6G6hSe8xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 06:26 AM, Alexey Dobriyan wrote:
> On Fri, Mar 23, 2012 at 7:50 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org>  wrote:
>> On Fri, 2012-03-23 at 13:00 +1100, Stephen Rothwell wrote:
>>> Hi James,
>>>
>>> After merging the scsi tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> drivers/ata/sata_svw.c: In function 'k2_sata_proc_open':
>>> drivers/ata/sata_svw.c:327:2: error: implicit declaration of function 'PDE' [-Werror=implicit-function-declaration]
>>> drivers/ata/sata_svw.c:327:56: error: invalid type argument of '->' (have 'int')
>>> drivers/ata/sata_svw.c:328:1: warning: control reaches end of non-void function [-Wreturn-type]
>>>
>>> Caused by commit 343ac4b031a7 ("[SCSI] sata_svw: convert to scsi proc_ops").
>>>
>>> I have used the scsi tree from next-20120322 for today.
>>
>> Additionally, I am the author and maintainer of that driver and I don't
>> remember ever being CCed on that patch ... or did I miss it ?
>
> Your email was not mentioned in changelogs for 6 years nor the driver
> has specific MAINTAINERS entry.


At the top of drivers/ata/sata_svw.c, we find:

  *  Maintained by: Benjamin Herrenschmidt <benh@kernel.crashing.org> and
  *                 Jeff Garzik <jgarzik@pobox.com>
  *                  Please ALWAYS copy linux-ide@vger.kernel.org
  *                  on emails.

and in MAINTAINERS we also find

SERIAL ATA (SATA) SUBSYSTEM
M:      Jeff Garzik <jgarzik@pobox.com>
L:      linux-ide@vger.kernel.org
T:      git 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
S:      Supported
F:      drivers/ata/

None of these addresses, nor LKML, were copied.  Please do so in the future.

	Jeff



