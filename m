Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0DOH36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0DOH3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:53 -0400
Message-ID: <4BC6C0CD.3020201@cn.fujitsu.com>
Date: Thu, 15 Apr 2010 15:31:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 5/6] menuconfig: add support to show hidden options which
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>	<4BC53A7A.5080502@cn.fujitsu.com> <20100414164839.e3c9391d.randy.dunlap@oracle.com>
In-Reply-To: <20100414164839.e3c9391d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/scripts/kconfig/mconf.c
>> +++ b/scripts/kconfig/mconf.c
>> @@ -67,13 +67,15 @@ static const char mconf_readme[] = N_(
>>  "             there is a delayed response which you may find annoying.\n"
>>  "\n"
>>  "   Also, the <TAB> and cursor keys will cycle between <Select>,\n"
>> -"   <Exit> and <Help>\n"
>> +"   <Exit> and <Help>.\n"
>>  "\n"
>>  "o  To get help with an item, use the cursor keys to highlight <Help>\n"
>> -"   and Press <ENTER>.\n"
>> +"   and press <ENTER>.\n"
>>  "\n"
>>  "   Shortcut: Press <H> or <?>.\n"
>>  "\n"
>> +"o  To show hidden options, press <Z>.\n"
> 
> maybe:
>        To toggle the display of hidden options, press <Z>.
> or     To alternate the ...
> ?
> 

Sure, it does looks better. will include this change
in a next patchset.

>> +"\n"
>>  "\n"
>>  "Radiolists  (Choice lists)\n"
>>  "-----------\n"
