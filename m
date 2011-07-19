Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1GSICR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:02:17 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38778 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab1GSICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:02:16 -0400
Message-ID: <4E253A02.9020806@dsn.okisemi.com>
Date: Tue, 19 Jul 2011 17:02:10 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110704163137.GA28042@ponder.secretlab.ca> <4E128A7D.9020508@dsn.okisemi.com> <20110705035902.GB13713@ponder.secretlab.ca> <4E12A69C.8030709@dsn.okisemi.com> <4E1AB3F7.2070600@dsn.okisemi.com> <20110715201414.GK2833@ponder.secretlab.ca>
In-Reply-To: <20110715201414.GK2833@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/16 5:14), Grant Likely wrote:
> Sounds like the platform is not correctly reserving the irq descs it
> is using.  You'll need to dig into the irq desc allocation code to
> debug it.
>

We can't.
It's difficult for us to debug irq platform code.

 > TO: Thomas Gleixner
Could you give us your opinion about this issue?

Thanks,

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
