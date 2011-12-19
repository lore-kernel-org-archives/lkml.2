Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1LSPFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:05:34 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:58863
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880Ab1LSPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:05:31 -0500
Message-ID: <4EEF52B2.6020503@compulab.co.il>
Date: Mon, 19 Dec 2011 17:05:22 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL: add power off functionality
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il> <4ED205F9.3070908@compulab.co.il> <4EE71FCA.8040000@compulab.co.il> <20111219113645.GI11800@sortiz-mobl>
In-Reply-To: <20111219113645.GI11800@sortiz-mobl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 13:36, Samuel Ortiz wrote:
> Hi Igor,
> 
> On Tue, Dec 13, 2011 at 11:50:02AM +0200, Igor Grinberg wrote:
>> Samuel,
>>
>> Can we get this one into 3.3?
> Afaiu, af8db1508f2c9f3b6e633e2d2d906c6557c617f9 needs to be (partially)
> reverted for it to be working. Is the core PM fix queued for 3.3 as well ? 

As Neil already said, the fix is already in Linus' tree:
fe6b91f47080eb17d21cbf2a39311877d57f6938
(PM / Driver core: leave runtime PM enabled during system shutdown)

I've tested the patch on top of v3.2-rc5 and it works fine.

-- 
Regards,
Igor.
