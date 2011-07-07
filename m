Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GGXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:51:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:43262 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550Ab1GGXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:51:07 -0400
Message-ID: <4E164665.4030002@dsn.okisemi.com>
Date: Fri, 08 Jul 2011 08:51:01 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vinod Koul <vkoul@infradead.org>
CC: Alexander Stein <alexander.stein@systec-electronic.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com>	 <201106271622.52763.alexander.stein@systec-electronic.com>	 <4E09AE3A.8050306@dsn.okisemi.com>	 <201106290828.06508.alexander.stein@systec-electronic.com>	 <4E0AFDCA.3050908@dsn.okisemi.com> <1310002731.20150.5.camel@psiaudioba-mobl1>
In-Reply-To: <1310002731.20150.5.camel@psiaudioba-mobl1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/07 10:38), Vinod Koul wrote:
> On Wed, 2011-06-29 at 19:26 +0900, Tomoya MORINAGA wrote:
>> (2011/06/29 15:28), Alexander Stein wrote:
>>> Are you sure you applied the patch? There shouldn't be a _raw_spin_lock_bh
>>> here.
>>>
>>
>> You are right.
>> I tested again, as a result,
>> I could confirm that after using your patch,
>> kernel error message doesn't logged at all.
>> It seems my patching yesterday was failed or operation mistake.
>> Sorry for the in inconvenience.
>>
> Care to send tested your by, before I apply this patch?
>

We are now doing long duration test.
After the test finish, I will report to you.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
