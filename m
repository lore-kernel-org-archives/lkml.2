Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1FTBIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 21:08:06 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27455 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab1FTBID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 21:08:03 -0400
Message-ID: <4DFE9D6F.4030107@dsn.okisemi.com>
Date: Mon, 20 Jun 2011 10:07:59 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
References: <4DEDBE90.3090305@dsn.okisemi.com> <20110607172211.GF17754@ponder.secretlab.ca>
In-Reply-To: <20110607172211.GF17754@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant

(2011/06/08 2:22), Grant Likely wrote:
>
> You don't need to implement new irq_chip
> operations if you use the new irq_chip_generic implementation.
>

I have recently started implementing GPIO interrupt using irq_chip_generic.
However, the compile becomes failed.
   irq_alloc_generic_chip: undefined reference
   irq_setup_generic_chip: undefined reference

It seems irq_chip_generic is only ARM code.(linux-3.0-rc3)
Does X86 support irq_chip_generic ?


-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
