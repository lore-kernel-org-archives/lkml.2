Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2EVNYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:24:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33803 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2EVNYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:24:03 -0400
Date: Tue, 22 May 2012 06:22:31 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
Message-ID: <20120522132231.GA31275@lizard>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
 <4F9C1CF5.3050706@linaro.org>
 <20120505120835.GA26976@lizard>
 <4FBB79D5.7030108@linaro.org>
 <20120522115638.GA19506@lizard>
 <4FBB8076.7010709@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBB8076.7010709@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 01:03:02PM +0100, Lee Jones wrote:
[...]
> >Now once Linus Torvalds pull battery tree, I'll ask Greg KH to
> >cherry-pick the patches into -stable.
> 
> Thanks Anton.
> 
> Are these queued up for the v3.5 merge window also?

Yep. :-)

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
