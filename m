Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1GYVZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:25:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1GYVZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:25:03 -0400
Message-ID: <4E2DDF23.8050806@suse.cz>
Date: Mon, 25 Jul 2011 23:24:51 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiromu Yakura <hiromu1996@gmail.com>
Subject: Re: [PATCH] xconfig: merge code path to conf_write()
References: <1306260978-29437-1-git-send-email-lacombar@gmail.com>	<20110525131854.GF2276@sepie.suse.cz>	<4E2D7571.8030108@suse.cz> <CACqU3MXmMejkTuUPqWQZH6BSXp6q_B5QuVNZbNjU=3s4sukagg@mail.gmail.com>
In-Reply-To: <CACqU3MXmMejkTuUPqWQZH6BSXp6q_B5QuVNZbNjU=3s4sukagg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.7.2011 17:25, Arnaud Lacombe wrote:
> Hi Michal,
> 
> On Mon, Jul 25, 2011 at 9:53 AM, Michal Marek <mmarek@suse.cz> wrote:
>> On 25.5.2011 15:18, Michal Marek wrote:
>>>
>>> The following patch avoids the data loss if the configuration cannot be
>>> saved.
>>>
>>> Michal
>>>
>>> Subject: [PATCH] xconfig: Abort close if configuration cannot be saved
>>>
>>> Give the user an opportunity to fix the error or save the configuration
>>> under a different path.
>>>
>>> Reported-by: Hiromu Yakura<hiromu1996@gmail.com>
>>> Signed-off-by: Michal Marek<mmarek@suse.cz>
>>
>> I completely forgot about this patch. It's applied now and will be in 3.1.
>>
> gni ? isn't this issue already fixed by
> https://patchwork.kernel.org/patch/812862/ which went in v3.0 ??

That's the prerequisite. This patch makes sure that xconfig does not
exit if the save failed.

Michal
