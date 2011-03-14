Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1CNC3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 22:29:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49346 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1CNC27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 22:28:59 -0400
Message-ID: <4D7D7DCD.7010200@cn.fujitsu.com>
Date: Mon, 14 Mar 2011 10:30:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3]trace-cmd: remove dead code
References: <4D78A0A4.1040001@cn.fujitsu.com> <1299768818.15854.343.camel@gandalf.stny.rr.com>
In-Reply-To: <1299768818.15854.343.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-14 10:27:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-14 10:27:38,
	Serialize complete at 2011-03-14 10:27:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 10:53 PM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 17:57 +0800, Lai Jiangshan wrote:
>> filter_cpu related code is totally dead.
> 
> I'll rephrase this, as it is not dead. "dead" code is code that can not
> be reached. This code most certainly can be reached. You may think it is
> silly code, which it may be. The reason for the separation of one CPU
> and multiple CPUs, is I do one CPU more often than I filter multiple,
> and I wanted the 1 cpu to still be efficient.
> 

I'm confused, filter_cpu is always -1, how the code can be reached?
