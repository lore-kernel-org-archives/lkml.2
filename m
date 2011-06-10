Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab1FJTx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:53:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab1FJTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:53:56 -0400
Message-ID: <4DF27642.1080208@oracle.com>
Date: Fri, 10 Jun 2011 12:53:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 26 (drivers/base/node.c)
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au> <20110526120121.db0506de.randy.dunlap@oracle.com> <20110610084405.c34a166d.randy.dunlap@oracle.com> <20110610183108.GB10575@kroah.com>
In-Reply-To: <20110610183108.GB10575@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DF2764C.00E4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/11 11:31, Greg KH wrote:
> On Fri, Jun 10, 2011 at 08:44:05AM -0700, Randy Dunlap wrote:
>> On Thu, 26 May 2011 12:01:21 -0700 Randy Dunlap wrote:
>>
>>> On Thu, 26 May 2011 16:39:41 +1000 Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> [The kernel.org mirroring is being slow today]
>>>
>>>
>>> when CONFIG_PROC_FS is not enabled:
>>>
>>> drivers/built-in.o: In function `node_read_vmstat':
>>> node.c:(.text+0x56ffa): undefined reference to `vmstat_text'
>>
>> Hi Greg,
>>
>> How do you want this build problem fixed?  (still around in
>> linux-next-20110610)
> 
> A patch would be great.

Yes, I was looking for general suggestions about such a patch,
but I'll just submit one and you can comment on it.

> But honestly, I really find that CONFIG_PROC_FS disabled to not be a
> valid configuration anymore.  I don't know anyone who can successfully
> run a machine in that manner, do you?

then why don't you submit a patch to remove that config option?
We could use fewer config options IMO.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
