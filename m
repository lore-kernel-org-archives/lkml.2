Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1LDWDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 17:03:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55665 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab1LDWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 17:03:53 -0500
Date: Sun, 4 Dec 2011 20:01:39 -0200 (BRST)
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
X-X-Sender: marcos@cactuar.localhost
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] staging: vt6655: card.c, srom.c, vntwifi.c: Code
 cleanup
In-Reply-To: <20111203083215.GF3195@mwanda>
Message-ID: <alpine.LNX.2.00.1112042000070.5963@cactuar.localhost>
References: <1322855892-6400-1-git-send-email-marcos.mage@gmail.com> <20111203083215.GF3195@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Dec 2011, Dan Carpenter wrote:
> On Fri, Dec 02, 2011 at 07:58:12PM +0000, Marcos Paulo de Souza wrote:
>> This patch removes commented code, useless comments, blank lines and fix
>> coding style of the headers of functions.
>>
>> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: devel@driverdev.osuosl.org
>> ---
>>  /*
>> - * Description: Test if bits off in eeprom
>> - *
>> - * Parameters:
>> - *  In:
>> - *      dwIoBase        - I/O base address
>> - *      byContntOffset  - address of EEPROM
>> - *      byTestBits      - bits to test
>> - *  Out:
>> - *      none
>> - *
>> - * Return Value: true if all test bits off; otherwise false
>> - *
>> + * Test if bits off in eeprom
>>   */
>
> Some of these seems sort of useful.  It might be better to change
> them to doc-book format instead of deleting them:
>
> /**
> * SROMbIsRegBitsOff() - Test if bits off in eeprom
> * @dwIoBase:       I/O base address
> * @byContntOffset: Address of EEPROM
> * @byTestBits:     Bits to test
> *
> * Returns true if all test bits off; otherwise false.
> */
>
> There is a howto in Documentation/kernel-doc-nano-HOWTO.txt.

Thanks for the suggestion Dan. I will do it for these 3 patches.

Greg, please delte this patches, I will sent them again.

Regards,

Marcos Paulo de Souza

> regards,
> dan carpenter
>
>
