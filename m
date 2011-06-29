Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1F2EZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 00:25:53 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38256 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab1F2EZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 00:25:46 -0400
Message-ID: <4E0AA947.3060201@dsn.okisemi.com>
Date: Wed, 29 Jun 2011 13:25:43 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <201106271622.52763.alexander.stein@systec-electronic.com> <4E09AE3A.8050306@dsn.okisemi.com> <201106281314.51722.alexander.stein@systec-electronic.com> <4E0AA451.5040506@dsn.okisemi.com>
In-Reply-To: <4E0AA451.5040506@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/29 13:04), Tomoya MORINAGA wrote:
> Hi Alexander,
> 
> (2011/06/28 20:14), Alexander Stein wrote:
>> Odd. What does addr2line report for 0xc0710cc5 and for 0xc07110d0?
>>
> 
> addr2line -e a.out 0xc0710cc5 0xc07110d0
> ??:0
> ??:0
> 
> Is the above command true ?
> If not, could you tell me how to use addr2line ?
> 

I can get the information.
[root@localhost morinaga]# addr2line -e vmlinux 0xc0710cc5 0xc07110d0
/home/morinaga/KORG/linux-2.6.39.y/drivers/dma/pch_dma.c:409
/home/morinaga/KORG/linux-2.6.39.y/include/linux/list.h:188

Best Regards,
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
