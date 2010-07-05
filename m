Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0GEBUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 21:20:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45492 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab0GEBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 21:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e9NuvllhvbXQ1BiyrjCyJmdsDxmGER+RmydQOlAhu1AUmHiIbK6G2CL6rCDq0gdLT4
         XXV3JjcID92xg792oO3w16/02xfeIrjNshH5wYTPHK0UmfrLz4HluhxmmcMrlpDhXIre
         m2so4DwaDfMM3fmiJSOF8HM7h53Yu2aWGPLII=
Message-ID: <4C313333.8070507@gmail.com>
Date: Sun, 04 Jul 2010 18:19:47 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11pre) Gecko/20100626 Shredder/3.0.6pre
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/3] Bcache: Version 6
References: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com> <20100704133434.fb23cc37.randy.dunlap@oracle.com>
In-Reply-To: <20100704133434.fb23cc37.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2010 01:34 PM, Randy Dunlap wrote:
> On Sun, 4 Jul 2010 00:44:18 -0700 Kent Overstreet wrote:
>> +  make-bcache /dev/sde
>> +  echo "/dev/sde">  /sys/kernel/bcache/register_cache
>> +  echo "<UUID>  /dev/md1">  /sys/kernel/bcache/register_dev
>
> Hi,
>
> Where does one find 'make-bcache'?
> Maybe that info could be added here.

Yeah, that should be there -
git://evilpiepirate.org/~kent/bcache-tools.git

Added it to the documentation, probably well past time to add some 
documentation to the user space stuff too..

>> --- a/block/Kconfig
>> +++ b/block/Kconfig
>> @@ -77,6 +77,20 @@ config BLK_DEV_INTEGRITY
>>   	T10/SCSI Data Integrity Field or the T13/ATA External Path
>>   	Protection.  If in doubt, say N.
>>
>> +config BLK_CACHE
>> +	tristate "Block device as cache"
>> +	default m
>
> We try not to add (enable) non-core drivers to the kernel build.
> OTOH, in a year or a few, this could be a core driver.

Alright, turned that off.

It's certainly getting to be quite a lot of code, is there anything I 
can do to make it easier to look at? I really appreciate you taking the 
time.
