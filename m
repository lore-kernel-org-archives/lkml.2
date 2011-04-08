Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab1DHTF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:05:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60466 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab1DHTF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:05:57 -0400
Message-ID: <4D9F5C7F.6020001@zytor.com>
Date: Fri, 08 Apr 2011 12:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Link: tags for new submission -- UPDATE
References: <4D9CE4AE.4090303@zytor.com> <1302185312.3329.1240.camel@twins>	 <4D9DCDAB.9000707@zytor.com> <1302188050.9086.27.camel@twins>	 <4D9DD08C.2080101@zytor.com> <1302188635.9086.44.camel@twins> <4D9DD62E.2050308@zytor.com>
In-Reply-To: <4D9DD62E.2050308@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 08:20 AM, H. Peter Anvin wrote:
> On 04/07/2011 08:03 AM, Peter Zijlstra wrote:
>>
>> D'0h ok.. but the scheme would work with any generated msgid, all we
>> need is to generate one for commits that lack a Link tag and insert it
>> using the prepare-commit-msg/commit-msg hooks and for the post-commit
>> hook to recognize it and use that actual msgid.
>>
>> The only thing to avoid is msgid collision, but given that MUAs already
>> have this problem all we need to do is borrow some of their logic.
>>
> 
> OK, this doesn't really need any hooks at all (the tip-bot is not a
> hook).  The committer is, and *has to be* responsible for getting the
> unique string into the Link: tag, through whatever means they feel is
> appropriate.
> 
> Based on the previous message, I'm going to modify the bot to recognize
> the pattern:
> 
> Link: http://lkml.kernel.org/r/tip-`ranpwd -l 24`@git.kernel.org
> 
> ... to override the Message-ID.  It seems like the least ugly of a lot
> of ugly options.
> 

<<<< IMPORTANT CHANGE >>>>

Please use the format:

Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
                             ^

... with an "n" for "new" instead of "r" for "reference" instead.

This allows the bot to distinguish a "new submission" link from a
*reference* to a message that was created as a result of a new submission!

	-hpa


