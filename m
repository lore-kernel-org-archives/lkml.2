Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2CZJOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:14:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61774 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2CZJON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:14:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Mon, 26 Mar 2012 11:14:20 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't
 explictly specified
In-reply-to: <20120322214714.GA24684@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: hskinnemoen@gmail.com, linux@arm.linux.org.uk,
        Rade Bozic <rade.bozic.ext@nsn.com>, ben-linux@fluff.org,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        bigeasy@linutronix.de, m.szyprowski@samsung.com,
        grant.likely@secretlab.ca, kyungmin.park@samsung.com,
        David Daney <ddaney@caviumnetworks.com>
Message-id: <4F70336C.70205@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
 <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com>
 <4F6B4532.7090806@samsung.com> <20120322214714.GA24684@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2012 22:47, Wolfram Sang wrote:

>> Dear Haavard, Rade, Wolfram and Russel
>>
>> Could you review following changes for gpio, octeon, pca-platform
>> and versatile i2c controller drivers (for which you are, or were,
>> maintainers)?
>>
>> Grant requested explicit Ack to get this merged.
> 
> ? Since those are I2C patches, I was assuming that I pick them. After the merge
> window, that is. Did I miss something?

That's all fine by me. I just wanted confirmation from respective
maintainers that changes I'm doing are ok for them.

... and it looks changes to i2c-octeon are redundant in light of
the work maintainer has done. I'll drop this part and repost patch
again.

Thanks.
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
