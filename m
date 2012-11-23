Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab2KWHyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:54:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43934 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2KWHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:54:51 -0500
Date: Thu, 22 Nov 2012 23:51:39 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linaro-kernel@lists.linaro.org,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/10] ARM: FIQ: Get rid of init_FIQ()
Message-ID: <20121123075138.GA2136@lizard>
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
 <1353652071.755665772@f76.mail.ru>
 <20121123065002.GB27827@lizard>
 <1353656161.911816605@f287.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353656161.911816605@f287.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 11:36:01AM +0400, Alexander Shiyan wrote:
[...]
> got_no_fiq_insn also not initialized.

It is static, so by definition it is initialized to 0.

> I think as a whole on this issue requires additional comments from Russell
> as the author of implementation.
> 
> PS: In any case, I can reproduce it and check it out if you send me a patchset
> to my email as an attachment.

Sent privately.

Thanks,
Anton.
