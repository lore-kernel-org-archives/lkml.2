Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab1CXHyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:54:38 -0400
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:40664 "EHLO
	smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933351Ab1CXHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:54:36 -0400
Message-ID: <4D8AF916.4020902@gmail.com>
Date: Thu, 24 Mar 2011 08:56:06 +0100
From: =?ISO-8859-15?Q?Ren=E9_Herman?= <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Lanikai/3.1.9
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.38] drm/i915: rampant video-corruption on Intel 865G
References: <4D8A668B.9070302@gmail.com> <849307$c4qsv5@azsmga001.ch.intel.com>
In-Reply-To: <849307$c4qsv5@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1Q2fNK-0007lp-VE
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=-3.639, vereist 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, FREEMAIL_FROM 0.50, PROLO_TRUST_RDNS -3.00,
	RDNS_DYNAMIC 0.98, SPF_NEUTRAL 0.78)
X-ZiggoSMTP-MailScanner-From: rene.herman@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 08:21 AM, Chris Wilson wrote:

Thanks for the reply. I see that:

> commit 29c5a587284195278e233eec5c2234c24fb2c204
> Author: Chris Wilson<chris@chris-wilson.co.uk>
> Date:   Thu Mar 17 15:23:22 2011 +0000
>
>      drm/i915: Fix tiling corruption from pipelined fencing

is not in Linus' tree, so I haven't been able to confirm yet. I do 
suppose that one should fix things even without the X11 changes? If not, 
I'd still have a problem until those have made their way through the 
distributions...

Regards,
Rene.
