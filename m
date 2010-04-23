Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0DWUTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:19:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19753 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0DWUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:19:53 -0400
Message-ID: <4BD200BB.1070709@oracle.com>
Date: Fri, 23 Apr 2010 13:19:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
References: <20100423194107.GA20322@moria> <20100423130736.79db708a.randy.dunlap@oracle.com> <4BD20074.6020101@gmail.com>
In-Reply-To: <4BD20074.6020101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BD200E8.008B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/10 13:17, Kent Overstreet wrote:
> On 04/23/2010 12:07 PM, Randy Dunlap wrote:
>>     help
>>     <some explanatory help text>
>> please.  The tristate prompt didn't do anything for me.
> 
> Did the prompt not show up at all? That's odd, I wouldn't have thought
> help text would have anything to do with that - I just added help to the
> kconfig, though. I'll have it up in a git repository soon, I don't
> suppose I should be posting a 2.4k line patch multiple times per day...

I'm just saying that it needs help text -- the prompt doesn't say enough.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
