Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1A1Uzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:55:55 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:16794 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982Ab1A1Uzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:55:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAKe8Qk1Ld/sX/2dsb2JhbAAMhAjLSZBqgSODOHQEhRg
X-IronPort-AV: E=Sophos;i="4.60,394,1291611600"; 
   d="scan'208";a="89633189"
Message-ID: <4D432D47.2000600@teksavvy.com>
Date: Fri, 28 Jan 2011 15:55:35 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D40C3D7.90608@teksavvy.com> <4D40C551.4020907@teksavvy.com> <20110127021227.GA29709@core.coreip.homeip.net> <4D40E41D.2030003@teksavvy.com> <20110127163931.GA1825@core.coreip.homeip.net> <4D41B5A0.70704@teksavvy.com> <20110127195325.GB29910@core.coreip.homeip.net> <20110128164244.GB6252@core.coreip.homeip.net>
In-Reply-To: <20110128164244.GB6252@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-28 11:42 AM, Dmitry Torokhov wrote:
> On Thu, Jan 27, 2011 at 11:53:25AM -0800, Dmitry Torokhov wrote:
>> On Thu, Jan 27, 2011 at 01:12:48PM -0500, Mark Lord wrote:
>>> On 11-01-27 11:39 AM, Dmitry Torokhov wrote:
..
>>>> Hmm, what about compiling with debug and getting a core then?
>>>
>>> Sure.  debug is easy, -g, but you'll have to tell me how to get it
>>> do produce a core dump.
>>>
>>
>> See if adjusting /etc/security/limits.conf will enable it to dump core.
>> Otherwise you'll have to stick 'ulimit -c unlimited' somewhere...
..
> Any luck with getting the core? I'd really like to resolve this issue.
..

I'm upgrading the box to new userspace now.
But I still have the old installation drive,
so perhaps I'll go there now and try this.

My plan is to replace /usr/bin/ir-keytable with a script
that issues the 'ulimit -c unlimited' command and then
invokes the original /usr/bin/ir-keytable binary.

Should take half an hour or so before I get back here again.

-ml
