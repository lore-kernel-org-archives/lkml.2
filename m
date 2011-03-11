Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1CKSlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:41:32 -0500
Received: from mx2.compro.net ([12.186.155.4]:51559 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1CKSlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:41:31 -0500
X-IronPort-AV: E=Sophos;i="4.62,304,1297054800"; 
   d="scan'208";a="6396194"
Message-ID: <4D7A6CDA.4070402@compro.net>
Date: Fri, 11 Mar 2011 13:41:30 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kernel git bisect question
References: <4D793414.4090206@compro.net> <20110310215438.GE12521@home.goodmis.org> <4D7A6A99.5070304@compro.net> <20110311183711.GA559@merkur.ravnborg.org>
In-Reply-To: <20110311183711.GA559@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 01:37 PM, Sam Ravnborg wrote:
> On Fri, Mar 11, 2011 at 01:31:53PM -0500, Mark Hounschell wrote:
>> On 03/10/2011 04:54 PM, Steven Rostedt wrote:
>>> On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
>>>> Between git bisect [good | bad ]s should I always "make clean" or can I
>>>> count on the build system to take care of everything properly?
>>>
>>
>> I'm trying to bisect between 2.6.35 and 2.6.36. What have I done wrong?
>> Here is exactly what I've done. Why after my second "git bisect bad" do
>> I get a Makefile for 2.6.35-rc1 and then after the fourth I get a Makefile
>> for 2.6.34??
> 
> The development is not linear.
> So you see a commit developed on top of 2.6.34 that was included in 2.6.35.
> This is normal.
> 

OK, thanks again. I'll continue on with the process then.

Mark
