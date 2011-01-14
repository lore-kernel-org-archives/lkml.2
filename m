Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1ANXtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:49:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11990 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab1ANXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:49:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6226"; a="70312617"
Message-ID: <4D30E109.3050500@codeaurora.org>
Date: Fri, 14 Jan 2011 15:49:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org> <4CF5DD63.40803@codeaurora.org> <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com> <4CF6AE04.6030201@codeaurora.org> <4CFE86AC.9010801@codeaurora.org> <20110114191956.GK4957@atomide.com>
In-Reply-To: <20110114191956.GK4957@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 11:19 AM, Tony Lindgren wrote:
> * Stephen Boyd <sboyd@codeaurora.org> [101207 11:00]:
>> On 12/01/2010 12:20 PM, Stephen Boyd wrote:
>>> Definitely for TX since it seems like a redundant loop, but I agree RX
>>> code has changed. Instead of
>>>
>>> If RX buffer full
>>> Poll for RX buffer full
>>> Read character from RX buffer
>>>
>>> we would have
>>>
>>> If RX buffer full
>>> Read character from RX buffer
>>>
>>> which doesn't seem all that different assuming the RX buffer doesn't go
>>> from full to empty between the If and Poll steps. Hopefully Tony knows more.
>>>
>>
>> Tony, any thoughts?
>
> Sorry for the delay, looks like I'm only 1 month behind with email..
> Sounds like it should work to me. I can try it out if you point me
> to a patch.

I think you acked the patches to make this change. You can test them out
by applying the "hvc_dcc cleanups and fixes" patches (Message-Id:
<1292875718-7980-1-git-send-email-sboyd@codeaurora.org>) on top of this
patch. They were sent as a reply to this thread.

Stephen

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

