Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935640Ab1JFAka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:40:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1251 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935355Ab1JFAk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:40:29 -0400
Message-ID: <4E8CF8F8.7090909@dsn.lapis-semi.com>
Date: Thu, 06 Oct 2011 09:40:24 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: Re: [PATCH 3/3] gpio-ml-ioh: Fix suspend/resume issue
References: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1312517062-5582-3-git-send-email-tomoya-linux@dsn.okisemi.com> <20111004160731.GA9084@ponder.secretlab.ca> <4E8BB327.50306@dsn.lapis-semi.com> <20111005175235.GC4205@ponder.secretlab.ca>
In-Reply-To: <20111005175235.GC4205@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/06 2:52), Grant Likely wrote:
> On Wed, Oct 05, 2011 at 10:30:15AM +0900, Tomoya MORINAGA wrote:
> Considering that the title of 3/3 is "Fix suspend/resume issue", you
> can understand my confusion.  I'm not talking about 1/3 because it
> looks like a trivial cleanup (not a bug fix).

I can understand your confusion.
As you said before,
2/3 is completely feature patch.
3/3 is bug-fix patch.
So, you can merge 3/3 into spi/merge, 1/3 and 2/3 into spi/next.

Thanks,

-- 
tomoya
ROHM Co., Ltd.
