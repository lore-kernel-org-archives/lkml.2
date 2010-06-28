Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0F1PIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:08:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61147 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0F1PIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:08:44 -0400
Message-ID: <4C28BAE3.8030909@oracle.com>
Date: Mon, 28 Jun 2010 08:08:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Nicolas Kaiser <nikai@nikai.net>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: fixed typos and wording
References: <20100626150021.254b95b3@absol.kitzblitz> <20100626173736.e5946273.randy.dunlap@oracle.com> <4C28B801.7050709@suse.cz>
In-Reply-To: <4C28B801.7050709@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C28BAF5.0169:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/10 07:56, Michal Marek wrote:
> On 27.6.2010 02:37, Randy Dunlap wrote:
>> On Sat, 26 Jun 2010 15:00:21 +0200 Nicolas Kaiser wrote:
>>
>>> Fixed some typos and wording.
>>>
>>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
>>
>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Randy, are you adding this to the kernel-doc tree? There are already
> patches from matt mooney, sometimes touching the same paragraphs as this
> one.

Oh, thanks for the warning, I hadn't noticed that.
I guess that it makes more sense for me to add this one also
and fix up any merge problems.  Will do.

> Michal
> 
>>
>> Thanks.
>>
>>> ---
>>>  Documentation/kbuild/kbuild.txt    |    8 ++++----
>>>  Documentation/kbuild/makefiles.txt |   20 ++++++++++----------
>>>  2 files changed, 14 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
>>> index 634c625..0d8addb 100644
>>> --- a/Documentation/kbuild/kbuild.txt
>>> +++ b/Documentation/kbuild/kbuild.txt
>>> @@ -40,15 +40,15 @@ Set the directory to look for the kernel source when building external
>>>  modules.
>>>  The directory can be specified in several ways:
>>>  1) Use "M=..." on the command line
>>> -2) Environmnet variable KBUILD_EXTMOD
>>> -3) Environmnet variable SUBDIRS
>>> +2) Environment variable KBUILD_EXTMOD
>>> +3) Environment variable SUBDIRS
>>>  The possibilities are listed in the order they take precedence.
>>>  Using "M=..." will always override the others.
>>>  
>>>  KBUILD_OUTPUT
>>>  --------------------------------------------------
>>>  Specify the output directory when building the kernel.
>>> -The output directory can also be specificed using "O=...".
>>> +The output directory can also be specified using "O=...".
>>>  Setting "O=..." takes precedence over KBUILD_OUTPUT.
>>>  
>>>  ARCH
>>> @@ -90,7 +90,7 @@ The script will be called with the following arguments:
>>>      $3 - kernel map file
>>>      $4 - default install path (use root directory if blank)
>>>  
>>> -The implmentation of "make install" is architecture specific
>>> +The implementation of "make install" is architecture specific
>>>  and it may differ from the above.
>>>  
>>>  INSTALLKERNEL is provided to enable the possibility to
>>> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
>>> index 71c602d..c0c9b1c 100644
>>> --- a/Documentation/kbuild/makefiles.txt
>>> +++ b/Documentation/kbuild/makefiles.txt
>>> @@ -284,12 +284,12 @@ more details, with real examples.
>>>  --- 3.7 Compilation flags
>>>  
>>>      ccflags-y, asflags-y and ldflags-y
>>> -	The three flags listed above applies only to the kbuild makefile
>>> -	where they are assigned. They are used for all the normal
>>> -	cc, as and ld invocation happenign during a recursive build.
>>> +	These three flags apply only to the kbuild makefile in which they
>>> +	are assigned. They are used for all the normal cc, as and ld
>>> +	invocations happening during a recursive build.
>>>  	Note: Flags with the same behaviour were previously named:
>>>  	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
>>> -	They are yet supported but their use are deprecated.
>>> +	They are still supported but their usage is deprecated.
>>>  
>>>  	ccflags-y specifies options for compiling C files with $(CC).
>>>  
>>> @@ -318,9 +318,9 @@ more details, with real examples.
>>>  		ldflags-y := -x
>>>  
>>>      subdir-ccflags-y, subdir-asflags-y
>>> -	The two flags listed above are similar to ccflags-y and as-falgs-y.
>>> -	The difference is that the subdir- variants has effect for the kbuild
>>> -	file where tey are present and all subdirectories.
>>> +	The two flags listed above are similar to ccflags-y and as-flags-y.
>>> +	The difference is that the subdir- variants have effect for the kbuild
>>> +	file where they are present and all subdirectories.
>>>  	Options specified using subdir-* are added to the commandline before
>>>  	the options specified using the non-subdir variants.
>>>  
>>> @@ -1176,14 +1176,14 @@ When kbuild executes, the following steps are followed (roughly):
>>>  === 7 Kbuild syntax for exported headers
>>>  
>>>  The kernel include a set of headers that is exported to userspace.
>>> -Many headers can be exported as-is but other headers requires  a
>>> +Many headers can be exported as-is but other headers require a
>>>  minimal pre-processing before they are ready for user-space.
>>>  The pre-processing does:
>>>  - drop kernel specific annotations
>>>  - drop include of compiler.h
>>> -- drop all sections that is kernel internat (guarded by ifdef __KERNEL__)
>>> +- drop all sections that are kernel internal (guarded by ifdef __KERNEL__)
>>>  
>>> -Each relevant directory contain a file name "Kbuild" which specify the
>>> +Each relevant directory contains a file name "Kbuild" which specifies the
>>>  headers to be exported.
>>>  See subsequent chapter for the syntax of the Kbuild file.



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
