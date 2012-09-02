Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2IBU1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:27:31 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:57945 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab2IBU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:27:30 -0400
Message-ID: <5043C139.2010700@metafoo.de>
Date: Sun, 02 Sep 2012 22:27:37 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 2/3] MIPS: JZ4740: Export timer API
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de> <1346579550-5990-3-git-send-email-thierry.reding@avionic-design.de> <50437117.8000700@metafoo.de> <20120902202124.GA21635@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120902202124.GA21635@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 10:21 PM, Thierry Reding wrote:
> On Sun, Sep 02, 2012 at 04:45:43PM +0200, Lars-Peter Clausen wrote:
>> On 09/02/2012 11:52 AM, Thierry Reding wrote:
>>> This is a prerequisite for allowing the PWM driver to be converted to
>>> the PWM framework.
>>>
>>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>
>> I'd prefer to keep the timer functions inline, some of them are called quite
>> often in the system clock code.
> 
> I've opted for this variant because it better hides the register values.
> If the functions are inlined it also means the complete register
> definitions need to go into timer.h. If you don't think that's an issue,
> I can update the patch accordingly.
> 

It's not pretty, but it should be ok. Having a single global function for each
and every register access is kind of ugly too.

- Lars
