Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab1JEBaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:30:19 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6489 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425Ab1JEBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:30:19 -0400
Message-ID: <4E8BB327.50306@dsn.lapis-semi.com>
Date: Wed, 05 Oct 2011 10:30:15 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] gpio-ml-ioh: Fix suspend/resume issue
References: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1312517062-5582-3-git-send-email-tomoya-linux@dsn.okisemi.com> <20111004160731.GA9084@ponder.secretlab.ca>
In-Reply-To: <20111004160731.GA9084@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

(2011/10/05 1:07), Grant Likely wrote:
> On Fri, Aug 05, 2011 at 01:04:22PM +0900, Tomoya MORINAGA wrote:
> Can this one be merged without 1/3 and 2/3?  Patch 2 looks like a
> feature instead of a bug fix.
>

Is the above true ?
I think,
1/3 is a bug fix.
2/3 and 3/3 are feature.

Do you mean you will merge only patch for a bug fix ?
What will you do feature patch ?
Anyway, please complete your review and merging.

BTW, could you review pch_gpio patch series I posted in July too ?

Thanks,
-- 
tomoya
ROHM Co., Ltd.
