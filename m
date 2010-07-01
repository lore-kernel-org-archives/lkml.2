Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0GAPr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:47:58 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43126 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab0GAPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:47:57 -0400
Message-ID: <4C2CB895.3030402@metafoo.de>
Date: Thu, 01 Jul 2010 17:47:33 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v3] MMC: Add JZ4740 mmc driver
References: <1276924111-11158-19-git-send-email-lars@metafoo.de> <1277688041-23522-1-git-send-email-lars@metafoo.de> <87aaqd1tmr.fsf@linux-g6p1.site>
In-Reply-To: <87aaqd1tmr.fsf@linux-g6p1.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Matt Fleming wrote:
> On Mon, 28 Jun 2010 03:20:41 +0200, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> This patch adds support for the mmc controller on JZ4740 SoCs.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Matt Fleming <matt@console-pimps.org>
>> Cc: linux-mmc@vger.kernel.org
>>
>> ---
>> Changes since v1
>> - Do not request IRQ with IRQF_DISABLED since it is a noop now
>> - Use a generous slack for the timeout timer. It does not need to be accurate.
>> Changes since v2
>> - Use sg_mapping_to iterate over sg elements in mmc read and write functions
>> - Use bitops instead of a spinlock and a variable for testing whether a request
>>   has been finished.
>> - Rework irq and timeout handling in order to get rid of locking in hot paths
> 
> Acked-by: Matt Fleming <matt@console-pimps.org>
> 
> Are you planning on maintaining this driver? If so, it'd be a good idea
> to update MAINTAINERS.

Hi

Thanks for reviewing the patch.
I guess I should send a MAINTAINERS patch which adds entries for all of the JZ4740
drivers.

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkwsuJUACgkQBX4mSR26RiNHVgCfTq+tc2I1QBniqijyUjNDxPIX
GsEAn1xgPWz+L0uqHWthzJ+lMtFaUBtY
=nVt9
-----END PGP SIGNATURE-----
