Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0DWUqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:46:13 -0400
Received: from 5-161-237-24-mvl.swc.gci.net ([24.237.161.5]:39078 "EHLO
	mail.adialaska.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159Ab0DWUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:46:09 -0400
Message-ID: <4BD2070E.5060103@gmail.com>
Date: Fri, 23 Apr 2010 12:46:06 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100421 Shredder/3.0.5pre
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
References: <20100423194107.GA20322@moria> <20100423130736.79db708a.randy.dunlap@oracle.com> <4BD20074.6020101@gmail.com> <4BD200BB.1070709@oracle.com>
In-Reply-To: <4BD200BB.1070709@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 12:19 PM, Randy Dunlap wrote:
> On 04/23/10 13:17, Kent Overstreet wrote:
>> On 04/23/2010 12:07 PM, Randy Dunlap wrote:
>>>      help
>>>      <some explanatory help text>
>>> please.  The tristate prompt didn't do anything for me.
>>
>> Did the prompt not show up at all? That's odd, I wouldn't have thought
>> help text would have anything to do with that - I just added help to the
>> kconfig, though. I'll have it up in a git repository soon, I don't
>> suppose I should be posting a 2.4k line patch multiple times per day...
>
> I'm just saying that it needs help text -- the prompt doesn't say enough.
>

Ah, right. It still needs real documentation in general, that should probably 
be a higher priority.

(Somewhat messy, will be rewritten) repo is up at
http://modzer0.cs.uaf.edu/~kent/linux-bcache.git, kconfig help is in. If 
there's something in particular you think ought to be documented for 
understanding the code, I'll do that now. End user documentation I was 
planning on waiting a bit on as I'm sure stuff is going to have to change.
