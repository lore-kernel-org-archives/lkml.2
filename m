Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab1D2XQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:16:30 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:39128 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934069Ab1D2XQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:16:28 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB469F.50804@verizon.net>
Date: Fri, 29 Apr 2011 19:15:43 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Michal Marek <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to scripts/docproc.c
References: <4DBB3DD4.9000000@verizon.net>	<20110429154649.848f9ba8.rdunlap@xenotime.net>	<4DBB42F9.7070407@suse.cz> <20110429160212.6662c08a.rdunlap@xenotime.net>
In-Reply-To: <20110429160212.6662c08a.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2011 7:02 PM, Randy Dunlap wrote:
> On Sat, 30 Apr 2011 01:00:09 +0200 Michal Marek wrote:
> 
>> On 30.4.2011 00:46, Randy Dunlap wrote:
>>> On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:
>>>
>>>> This patchset moves scripts/basic/docproc to scripts/docproc.
>>>> This causes docproc to only be built for *doc targets rather than every
>>>> time the kernel is compiled.
>>>>
>>>> Patches also attached as requested by Michal Marek.
>>>
>>>
>>> That's disappointing (the attachments).  Why was this requested?
>>>
>>> See Documentation/CodingStyle, section 7:
>>>
>>> "No MIME, no links, no compression, no attachments.  Just plain text."
>>
>> and a couple of lines later:
>> "Exception:  If your mailer is mangling patches then someone may ask
>> you to re-send them using MIME."
>>
>> Which is exactly what happened here - the patches had missing or excess
>> leading space and in some cases a context line was missing. So instead
>> of manually reconstructing the patches, I asked Peter to resend them as
>> attachments.
> 
> OK, thanks for explaining.
> 
>> BUT - I didn't request to split this patch into seven pieces. Splitting
>> patches into smaller parts is desired, but each part has to be self
>> contained and not break stuff when the later parts are not applied. So
>> when moving a .c file, then the corespoding Makefile changes need to be
>> contained in the same patch. No need to resend the patch now, I'll fold
>> the patches into one again, but please consider this next time.
> 
> Yes, a few of them could be merged IMO.
> 
>>> Instead, the saved file contains lines like
>>> this (below) and each patch 2 times (inline and attachment).
>>
>> Yeah, only sending the attachment would be better in this case.
> 
> agreed.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Thanks for all the feedback.
I'll try to take it into account in the future.

Thanks,

Peter





