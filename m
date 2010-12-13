Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0LMIAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:00:40 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:56160 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab0LMIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:00:39 -0500
Message-ID: <4D05D299.60106@euromail.se>
Date: Mon, 13 Dec 2010 09:00:25 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mt: Add button support for five fingers
References: <1292063308-15327-1-git-send-email-rydberg@euromail.se> <1292063308-15327-2-git-send-email-rydberg@euromail.se> <20101213025016.GC21401@core.coreip.homeip.net>
In-Reply-To: <20101213025016.GC21401@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PS3Kl-0000B4-83.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PS3Kl-0000B4-83 80e6cf1434576809cb26c972f5993bd4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 03:50 AM, Dmitry Torokhov wrote:

> On Sat, Dec 11, 2010 at 11:28:28AM +0100, Henrik Rydberg wrote:
>> This patch adds BTN_TOOL_QUINTAP to be used by hardware reporting
>> finger counts different from the number of MT contacts.
> 
> I must say this is quite ugly, but so is introducing ABS_CONTACT_COUNT
> or similar, except that the latter is more extensible so if
> manufacturers decide to report 6, 7, 8 fingers (but not their
> coordinates) we won't have to breed BTN_TOOL_xxxTAPs...
> 
> But let me ask you this: do we know what to do with 5 fingers? How do we
> plan to react to such gestures? Maybe the best option is simply ignore
> it and don't report anything if there are no userspace consumers?


I agree - let's put the bar at four fingers for special solutions. Dropped.

Thanks,
Henrik
