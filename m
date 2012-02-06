Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2BFUc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:32:29 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18188 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2BFUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:32:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6612"; a="160974262"
Message-ID: <c1f3d71b6001dfc42ded4ee651e9a82c.squirrel@www.codeaurora.org>
In-Reply-To: <20120203121847.1b01f4b5@s6510.linuxnetplumber.net>
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
    <4F2C38BD.1060109@codeaurora.org>
    <20120203121847.1b01f4b5@s6510.linuxnetplumber.net>
Date: Mon, 6 Feb 2012 12:32:27 -0800 (PST)
Subject: Re: [PATCH] tags: fix regex passed to etags
From: "Stephen Boyd" <sboyd@codeaurora.org>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "Stephen Boyd" <sboyd@codeaurora.org>, "Michal Marek" <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 03 Feb 2012 11:42:53 -0800
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> On 02/03/12 11:27, Stephen Hemminger wrote:
>> > Several of the regular expressions passed to etags where incorrect
>> > and missing the backslash before the closing parenthesis, causing
>> warning:
>> >   etags: Unmatched ( or \( while compiling pattern
>> >
>> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> >
>>
>> I'm confused how ctags didn't complain at me. It worked for me when I
>> tried it. Next time I'll try both. Thanks.
>>
>
> Most likely a new check in newer version of the tags command.
>

Actually it looks like ctags also needs the fix. Can you resend with
both etags and ctags fixed?

