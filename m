Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1GHHIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:08:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45232 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab1GHHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:08:29 -0400
Message-ID: <4E16ACE9.70908@dsn.okisemi.com>
Date: Fri, 08 Jul 2011 16:08:25 +0900
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
> Care to send tested your by, before I apply this patch?

We've just completed UART+DMA testing with success.
Please accept Alexander's patch for spin-lock.

Best Regards,
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
