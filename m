Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1JLGYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:24:10 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:46006 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab1JLGYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:24:09 -0400
Message-ID: <4E953285.5060807@dsn.lapis-semi.com>
Date: Wed, 12 Oct 2011 15:24:05 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2 v2] pch_dma: Reduce wasting memory
References: <1318379915-8697-1-git-send-email-tomoya-linux@dsn.lapis-semi.com> <1318397400.1546.368.camel@vkoul-udesk3>
In-Reply-To: <1318397400.1546.368.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/12 14:30), Vinod Koul wrote:
> Applied thanks.
>
> Although we can further optimize by removing static array and
> dynamically allocate channel structures based on nr_channels, that can
> be taken further separately.
>
Yes, I think so.
We will improve data memory structure using dynamic memory allocation 
based on nr_channels.

Thanks,
-- 
tomoya
ROHM Co., Ltd.
