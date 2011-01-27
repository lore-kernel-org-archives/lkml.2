Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1A0FtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:49:19 -0500
Received: from lo.gmane.org ([80.91.229.12]:59347 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1A0FtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:49:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Date: Thu, 27 Jan 2011 05:49:04 +0000 (UTC)
Message-ID: <ihr10g$qmm$2@dough.gmane.org>
References: <20110125235700.GR8008@google.com>
	<iho7ba$kmn$1@dough.gmane.org>
	<AANLkTikaDpZ=Pjb+m7ixCepywtO1bUN02sfimWBSTha3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 15:05:48 -0800, Mandeep Baines wrote:

> On Tue, Jan 25, 2011 at 8:18 PM, WANG Cong <xiyou.wangcong@gmail.com>
> wrote:
>>
>> On Tue, 25 Jan 2011 15:57:00 -0800, Mandeep Singh Baines wrote:
>>
>> > We've been burned by regressions/bugs which we later realized could
>> > have been triaged quicker if only we'd paid closer attention to
>> > dmesg. To make it easier to audit dmesg, we'd like to make
>> > DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
>> > KERN_NOTICE and audit any messages <= KERN_WARNING.
>> >
>> >
>> Why? We already have "loglevel=" kernel parameter.
>>
>>
> loglevel allows you to control which messages go to the console.
> 
> DEFAULT_MESSAGE_LEVEL selects the default message levels for printk()s
> which don't specify a message level.


I think you should fix them instead.

> 
> Most printks()s without a message level aren't really warnings and just
> create noise
> if you're trying to look closely at all warnings. Some of this is just
> old code but new
> printk()s without a message level do get committed from time to time.
> 

IIRC, checkpatch.pl will complain about this.


