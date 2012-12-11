Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2LKJkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:40:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56784 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2LKJkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:40:20 -0500
Message-ID: <50C6FF69.3030001@ti.com>
Date: Tue, 11 Dec 2012 10:39:53 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] leds: leds-pwm: Convert to use devm_get_pwm
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com> <3193669.Hv54bBklsP@barack> <20121211083632.GC27084@avionic-0098.adnet.avionic-design.de> <1406670.ryvqfkiNXS@barack> <20121211093100.GA8437@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121211093100.GA8437@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 10:31 AM, Thierry Reding wrote:
> On Tue, Dec 11, 2012 at 09:57:51AM +0100, Peter Ujfalusi wrote:
> Okay, if there are no intree users that may be broken, then it should be
> fine to remove it. In that case you might want to remove the pwm_id
> field as well instead of deprecating it in this patch.

The reason I marked the pwm_id as deprecated is to signal to out of tree users
(if any) that they should stop using it since it is going to go away in the
next cycle.
If we remove it right away the sdp4030 board file will not going to compile in
subsystem trees, only in linux-next.

-- 
Péter
