Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1EZMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:52:25 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:48206
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754704Ab1EZMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:52:24 -0400
Message-ID: <4DDE4D04.5070404@compulab.co.il>
Date: Thu, 26 May 2011 15:52:20 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap updates for 2.6.40
References: <20110526113905.GG27250@atomide.com> <4DDE441C.2080808@compulab.co.il> <20110526122412.GB11352@atomide.com>
In-Reply-To: <20110526122412.GB11352@atomide.com>
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

On 05/26/11 15:24, Tony Lindgren wrote:

> * Igor Grinberg <grinberg@compulab.co.il> [110526 05:10]:
>> What about this one: [PATCH v2] arm: omap2plus: move NAND_BLOCK_SIZE out of boards
>>
>> Why not include it? It is no new code, just generalize stuff and 11 lines off... not much but still.
> Sorry I must have missed it.. Let's see if we can queue it
> during the merge window as it's a trivial patch removing
> duplicate defines.

I'm failing to understand what do you mean by that...
According to Linus ("probably Sunday - I'll be on airplanes next Monday"),
the merge window will be closed soon.

Do you mean, you will send an updated pull request?


-- 
Regards,
Igor.

