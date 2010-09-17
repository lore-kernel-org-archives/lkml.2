Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0IQJxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:53:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33087 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0IQJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PkFZzgX06uZbmDNUHVSKyQhAThB3czxpDEtaZG9xX8zGVSRmgzB6/i9Cgz5QOFX+az
         Z5srLLKPQLnYwwhpu5RRK8c7W3I/H2HmS20xiQVYPzTs5DcCLaRGd4qNxmPo9CjqfmiS
         3lY9+MASl6V59xj89du3U9Nj+DvNMRsiS57/o=
Message-ID: <4C933A8F.2080305@gmail.com>
Date: Fri, 17 Sep 2010 11:53:19 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Pedro Francisco <pedrogfrancisco@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: ahci rmmodable and shouldn't
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
In-Reply-To: <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/16/2010 11:58 PM, Randy Dunlap wrote:
>> `rmmod ahci' works even if the module is being used (`lsmod' thinks it's
>> not being used but rmmoding ahci triggers filesystem erros and I've to
>> force a reboot).
>>
>> I've been told it's the same as plugging a cable. IMO that's what
>> /sys/stuff/eject_or_similar is to, not `rmmod ahci'.
>>
>>
>> I *assume* it was caused by the split between libahci & ahci, since in
>> 2.6.32
>> `rmmod ahci' is impossible because it's marked as being in use. Didn't try
>>  `rmmod -f ahci' but that's not the point.
>>
>>
>> I'm posting again about this because it doesn't make sense to me the
>> actual behaviour.

Just don't rmmod a module which is serving a live filesystem.  Why
does it even matter?

-- 
tejun
