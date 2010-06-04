Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0FDAzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:55:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756805Ab0FDAzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:55:09 -0400
Message-ID: <4C084F7F.9060802@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 08:57:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Michal Marek <mmarek@suse.cz>, Nobin Mathew <nobin.mathew@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] menuconfig: truncate list items
References: <4C0758B7.5070907@cn.fujitsu.com> <4C0758C9.7080108@cn.fujitsu.com> <4C07D932.4040404@oracle.com>
In-Reply-To: <4C07D932.4040404@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 06/03/10 00:24, Li Zefan wrote:
>> Truncate list items to fit in a single line, otherwise those items
>> which have long prompts will cover some other items.
>>
>> This follows the behavior of menubox.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks :)
> 
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Ben, the Samsung S3C24* prompt still gets truncated with this patch (when using
> an 80-column wide xterm).  If you care about seeing all of the models,
> you might want to shorten the prompt.
> 

An alterative is to print the truncated string and end it with "...":

( ) Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440...



