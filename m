Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2DZIog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:44:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:13618
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab2DZIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:44:33 -0400
X-SpamScore: -6
X-BigFish: PS-6(zz1432Nzz1202hzzz2fh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT004.namprd08.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F990AE0.8040400@ozmodevices.com>
Date: Thu, 26 Apr 2012 09:44:16 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix bug where kfree is called twice.
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com> <20120426063858.GC6447@mwanda>
In-Reply-To: <20120426063858.GC6447@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,
> It's a good patch and it fixes a bug, but could you resend with
> the subject:
>
> [PATCH] Staging: ozwpan: Fix bug where kfree is called twice.
Sorry about subject line. I should have spend a bit more time in 
formatting subject line.
However it looks like Greg have already pulled this patch in 
staging-next branch.
(Thanks Greg, for modifying subject line. I will be more careful next time.)

However, I will be happy if you still want me to resend this patch with 
correct subject line.

> We don't like to put a lot of bureaucracy infront of people
> submitting actual bugfixes.  But you guys are the new maintainers
> and you're going to need to know all this stuff eventually.  Also
> could you give us a hint how likely the users are to hit this?
> Should this go into 3.4 or only 3.5?
I would have loved to get this patch in 3.4 as I am observing occasional 
crashes.
However looks like Greg have queued it up for 3.5.
-- 
Regards,
Rupesh Guajre


