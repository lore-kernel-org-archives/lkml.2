Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1BWPpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:45:23 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59901 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1BWPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:45:22 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 10:45:22 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 23 Feb 2011 16:39:10 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/18] MAINTAINERS: Update WINBOND CIR pattern
In-Reply-To: <4D64E540.9030702@redhat.com>
References: <cover.1298439175.git.joe@perches.com> <ea1ef222215810169e9dd4c29b2e5c03cbd667e1.1298439175.git.joe@perches.com> <4D64E540.9030702@redhat.com>
Message-ID: <96fbf604e36c9ed463167d77b225f058@hardeman.nu>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 07:45:20 -0300, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 23-02-2011 02:42, Joe Perches escreveu:
>> commit 5b2e303f6df1e0b1a903950c5d613a20c8c71a37
>> ("[media] rc-core: convert winbond-cir")
>> moved the files, update the pattern.
>> 
>> cc: David Härdeman <david@hardeman.nu>
>> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: David Härdeman <david@hardeman.nu>

>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 2b4dfa4..c0548be 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6787,7 +6787,7 @@ F:	drivers/scsi/wd7000.c
>>  WINBOND CIR DRIVER
>>  M:	David Härdeman <david@hardeman.nu>
>>  S:	Maintained
>> -F:	drivers/input/misc/winbond-cir.c
>> +F:	drivers/media/rc/winbond-cir.c
>>  
>>  WIMAX STACK
>>  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

-- 
David Härdeman
