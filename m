Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0G1XM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:12:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56975 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0G1XMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:12:54 -0400
Message-ID: <4C50B971.10807@canonical.com>
Date: Wed, 28 Jul 2010 16:12:49 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 13/13] AppArmor: update Maintainer and Documentation/kernel-parameters.txt
References: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>	<1280199468-19680-14-git-send-email-john.johansen@canonical.com> <20100728104629.ddba3cc5.randy.dunlap@oracle.com>
In-Reply-To: <20100728104629.ddba3cc5.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 10:46 AM, Randy Dunlap wrote:
> On Mon, 26 Jul 2010 19:57:48 -0700 John Johansen wrote:
> 
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---
>>  Documentation/kernel-parameters.txt |   12 ++++++++++--
>>  MAINTAINERS                         |    8 ++++++++
>>  2 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 4ddb58d..b61f89f 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -93,6 +93,7 @@ parameter is applicable:
>>  			Documentation/scsi/.
>>  	SECURITY Different security models are enabled.
>>  	SELINUX SELinux support is enabled.
>> +	APPARMOR AppArmor support is enabled.
>>  	SERIAL	Serial support is enabled.
>>  	SH	SuperH architecture is enabled.
>>  	SMP	The kernel is an SMP kernel.
>> @@ -254,8 +255,8 @@ and is between 256 and 4096 characters. It is defined in the file
>>  			control method, with respect to putting devices into
>>  			low power states, to be enforced (the ACPI 2.0 ordering
>>  			of _PTS is used by default).
>> -			s4_nonvs prevents the kernel from saving/restoring the
>> -			ACPI NVS memory during hibernation.
>> +			nonvs prevents the kernel from saving/restoring the
>> +			ACPI NVS memory during suspend/hibernation and resume.
>>  			sci_force_enable causes the kernel to set SCI_EN directly
>>  			on resume from S1/S3 (which is against the ACPI spec,
>>  			but some broken systems don't work without it).
> 
> 
> Is that piece supposed to be part of this patch set?
> 
No, I'm not sure how that slipped in.  Thanks catching it.
