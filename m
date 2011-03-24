Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab1CXIRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:17:54 -0400
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:60517 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933686Ab1CXIRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:17:50 -0400
Message-ID: <4D8AFE86.7050803@gmail.com>
Date: Thu, 24 Mar 2011 09:19:18 +0100
From: =?ISO-8859-15?Q?Ren=E9_Herman?= <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Lanikai/3.1.9
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.38] drm/i915: rampant video-corruption on Intel 865G
References: <4D8A668B.9070302@gmail.com> <849307$c4qsv5@azsmga001.ch.intel.com> <4D8AF916.4020902@gmail.com> <849307$c4rj51@azsmga001.ch.intel.com>
In-Reply-To: <849307$c4rj51@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1Q2fjm-00076V-NK
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=-3.639, vereist 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, FREEMAIL_FROM 0.50, PROLO_TRUST_RDNS -3.00,
	RDNS_DYNAMIC 0.98, SPF_NEUTRAL 0.78)
X-ZiggoSMTP-MailScanner-From: rene.herman@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 09:00 AM, Chris Wilson wrote:

>> I do suppose that one [ the kernel one] should fix things even
>> without the X11 changes? If not, I'd still have a problem until
>> those have made their way through the distributions...
>
> No, the bugs are distinct, but very similar in appearance, and both
> updates are required.

That won't do then, will it? Kernel 2.6.38 then requires a new and not 
even released user space whereas 2.6.37 works fine. I suppose the fix 
will from the kernel side then need to be reverting to .37 behaviour, at 
least on the affected hardware? (855 and 865 at least).

Regards,
Rene
