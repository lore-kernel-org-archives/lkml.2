Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127Ab0EDVmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:42:00 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:43312 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933217Ab0EDVl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:41:59 -0400
Message-ID: <4BE09484.9000600@euromail.se>
Date: Tue, 04 May 2010 23:41:24 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@bitmath.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <20100415232523.GA18263@core.coreip.homeip.net> <4BDFD356.7070008@bitmath.org> <20100504172903.GB29428@core.coreip.homeip.net>
In-Reply-To: <20100504172903.GB29428@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O9Prq-00006r-CQ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1O9Prq-00006r-CQ c94496ac03d127184f7529fb5a01f922
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tue, May 04, 2010 at 09:57:10AM +0200, Henrik Rydberg wrote:
>>> It would be nice to use abs[ABS_MT_MAX - ABS_MT_TOUCH_MAJOR] to save
>>> some memory.
>>>
>> Is it possible this was meant to read "ABS_MAX - ABS_MT_TOUCH_MAJOR"? It would
>> explain my confusion.
>>
> 
> By ABS_MT_MAX I meant highest MT event currently defined. No need to go all
> the way to ABS_MAX if there are no MT events defined there.
> 

I see, thanks.

Henrik
