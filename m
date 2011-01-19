Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1ASQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:10:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42022 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1ASQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:10:55 -0500
Message-ID: <4D370CE6.3000505@oracle.com>
Date: Wed, 19 Jan 2011 08:10:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 18 (__modver_version_show)
References: <20110118122139.6c2a6f2f.sfr@canb.auug.org.au>	<20110118091749.ac5823df.randy.dunlap@oracle.com> <20110119160951.2a14d0a0.sfr@canb.auug.org.au>
In-Reply-To: <20110119160951.2a14d0a0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/11 21:09, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Tue, 18 Jan 2011 09:17:49 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> I'm seeing this on several builds (i386 and x86_64):
>>
>> lib/built-in.o:(__modver+0x8): undefined reference to `__modver_version_show'
>> lib/built-in.o:(__modver+0x2c): undefined reference to `__modver_version_show'
>>
>> It looks like the compiler or linker is dropping that function from the
>> build since it cannot see any references to it...
>> At least __modver_version_show is not in the kernel/params.o file.
> 
> Do these builds have CONFIG_SYSFS set?
> 

Yes, they all do (50 random builds have CONFIG_SYSFS=y).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
