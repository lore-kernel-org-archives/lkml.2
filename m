Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0DOIBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:01:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0DOIBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:01:05 -0400
Message-ID: <4BC6C81C.6020208@cn.fujitsu.com>
Date: Thu, 15 Apr 2010 16:02:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 5/6] menuconfig: add support to show hidden options which
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>	<4BC53A7A.5080502@cn.fujitsu.com> <20100414164839.e3c9391d.randy.dunlap@oracle.com> <4BC6C0CD.3020201@cn.fujitsu.com> <4BC6C635.5020107@suse.cz>
In-Reply-To: <4BC6C635.5020107@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15:54, Michal Marek wrote:
> On 15.4.2010 09:31, Li Zefan wrote:
>>>> +"o  To show hidden options, press <Z>.\n"
>>> maybe:
>>>        To toggle the display of hidden options, press <Z>.
>>> or     To alternate the ...
>>> ?
>>>
>> Sure, it does looks better. will include this change
>> in a next patchset.
> 
> Please send an incremental patch if you want to change the help text, I
> already merged your first version.
> 

That's what I meant. ;)

I'll do some more fixes and improvements, which is the phrase
"a next patchset" meant.
