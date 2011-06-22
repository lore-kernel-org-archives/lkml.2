Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1FVIOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:14:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2351 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab1FVION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:14:13 -0400
Message-ID: <4E01A452.8060801@dsn.okisemi.com>
Date: Wed, 22 Jun 2011 17:14:10 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201106211110.18171.alexander.stein@systec-electronic.com> <4E0132F4.7080506@dsn.okisemi.com> <201106220828.30516.alexander.stein@systec-electronic.com>
In-Reply-To: <201106220828.30516.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/22 15:28), Alexander Stein wrote:
> On Wednesday 22 June 2011 02:10:28 Tomoya MORINAGA wrote:
>> (2011/06/21 18:10), Alexander Stein wrote:
>>> I wrote a small program which use poll(2) on value, after edge hase been
>>> configured from shell. I cannot test the edge detection appropriately due
>>> to debouncing using jumpers.
>>
>> Really ?
>> In out test environment, my test program could detect edge interrupt
>> correctly.
>
> My test program used poll/select on edge successfully. But I could not test
> the raising or falling feature actually, as my input is bouncing. So, it
> doesn't matter if I set both/raising/falling in edge, due to my inputs the
> effect is the same. Any input event will end in several raising and falling
> interrupts events.
> I hope I could make this more clear.

Our test program also uses poll (We don't use select().)

BTW, is the above your saying related to your patch "[PATCH] pch_gpio: 
transform mutex into spinlock" ?


-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
