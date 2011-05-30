Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1E3UtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:49:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55285 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1E3UtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:49:10 -0400
Message-ID: <4DE402BD.4060407@zytor.com>
Date: Mon, 30 May 2011 13:49:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Turning off the incremental diff robot
References: <4DE3E9E7.8020008@zytor.com> <20110530194500.GE10792@home.goodmis.org>
In-Reply-To: <20110530194500.GE10792@home.goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2011 12:45 PM, Steven Rostedt wrote:
> On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
>> Hi all,
>>
>> With the v3.0 name change I was looking over what might break, and I'm
>> seriously considering turning off the incremental diff robot on
>> kernel.org.  It's not clear to me that it is actually useful anymore,
>> with git and all.
> 
> What is the incremental diff robot?
> 
> Does it make the patches between 2.6.x to 2.6.x+1?
> 

No, but it generates the patches between, say, 2.6.x.y and 2.6.x.y+1 or
2.6.x-rcy and 2.6.x-rcy+1.  Anything in an "incr" directory.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

