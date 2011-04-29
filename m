Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab1D2XJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:09:50 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:47008 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932525Ab1D2XJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:09:47 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB450E.7080208@verizon.net>
Date: Fri, 29 Apr 2011 19:09:02 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to scripts/docproc.c
References: <4DBB3DD4.9000000@verizon.net> <20110429154649.848f9ba8.rdunlap@xenotime.net>
In-Reply-To: <20110429154649.848f9ba8.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2011 6:46 PM, Randy Dunlap wrote:
> On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:
> 
>> This patchset moves scripts/basic/docproc to scripts/docproc.
>> This causes docproc to only be built for *doc targets rather than every
>> time the kernel is compiled.
>>
>> Patches also attached as requested by Michal Marek.
> 
> 
> That's disappointing (the attachments).  Why was this requested?
> 
> See Documentation/CodingStyle, section 7:
> 
> "No MIME, no links, no compression, no attachments.  Just plain text."
> 
> 
> It also causes breakage in other people's patch merging/testing.
> E.g., I cannot save any one of these emails as I can with other patches
> and get a useful patch file.  Instead, the saved file contains lines like
> this (below) and each patch 2 times (inline and attachment).
> 
> --------------060706070408040606010200
> Content-Type: text/plain;
> 	name="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"
> Content-Transfer-Encoding: 7bit
> Content-Disposition: attachment;
> 	filename="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"
> 
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

See https://lkml.org/lkml/2011/4/29/89 for the attachment request.
My current email client (thunderbird) seems to mangle any patches that I send.
If anybody can suggest an email client that doesn't mangle patches I'll be happy to try it.

Thanks,

Peter
