Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0LJNy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:54:56 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59365 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab0LJNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:54:54 -0500
Message-ID: <4D0230FF.6070207@euromail.se>
Date: Fri, 10 Dec 2010 14:54:07 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se> <20101210074351.GC21009@core.coreip.homeip.net>
In-Reply-To: <20101210074351.GC21009@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PR3QH-0004Yt-6J.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PR3QH-0004Yt-6J b496bcd442c43c158b7403f2a82f83f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 08:43 AM, Dmitry Torokhov wrote:

> On Thu, Dec 09, 2010 at 10:22:12PM +0100, Henrik Rydberg wrote:
>> The recent input-mt interface changes together with
>> recent discussions about pen and touch and support
>> for legacy multitouch pads suggest that the documentation
>> on MT tool types be expanded. This patch adds references
>> to the new interface, and adds a section for MT_TOOL types,
>> in particular documenting the use of MT_TOOL_ENVELOPE.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> 
> The explanation of the new types makes sense to me... Do you think we
> could add some comments directly to input.h?


Good idea, will do.

Thanks,
Henrik
