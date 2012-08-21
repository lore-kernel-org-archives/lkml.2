Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2HURoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:44:11 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48973 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932139Ab2HURoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:44:07 -0400
Message-ID: <5033C8DF.2080403@xenotime.net>
Date: Tue, 21 Aug 2012 10:43:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Richard Weinberger <richard@nod.at>, David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
References: <502A69FA.8040805@nod.at> <502A6759.3090802@nod.at> <15981.1344955883@warthog.procyon.org.uk> <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <18600.1344956051@warthog.procyon.org.uk> <18933.1344956788@warthog.procyon.org.uk> <30102.1344957328@warthog.procyon.org.uk> <502A6BF8.6040804@nod.at> <502A8DD6.90807@xenotime.net> <878vda5l8s.fsf@rustcorp.com.au>
In-Reply-To: <878vda5l8s.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 07:51 PM, Rusty Russell wrote:

> On Tue, 14 Aug 2012 10:41:42 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 08/14/2012 08:17 AM, Richard Weinberger wrote:
>>
>>> Am 14.08.2012 17:15, schrieb David Howells:
>>>> How about this then?
>>>>
>>>> David
>>>> ---
>>>> diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
>>>> index 9926e11..a4b0c10 100644
>>>> --- a/arch/x86/um/Kconfig
>>>> +++ b/arch/x86/um/Kconfig
>>>> @@ -21,9 +21,11 @@ config 64BIT
>>>>  config X86_32
>>>>  	def_bool !64BIT
>>>>  	select HAVE_AOUT
>>>> +	select MODULES_USE_ELF_REL
>>>>  
>>>>  config X86_64
>>>>  	def_bool 64BIT
>>>> +	select MODULES_USE_ELF_RELA
>>>>  
>>>>  config RWSEM_XCHGADD_ALGORITHM
>>>>  	def_bool X86_XADD && 64BIT
>>>
>>> Looks sane.
>>>
>>> Acked-by: Richard Weinberger <richard@nod.at>
>>
>>
>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks, folded into David's original patch.


When will this be fixed in linux-next?

linux-next of 20120821 still fails.

thanks,
-- 
~Randy
