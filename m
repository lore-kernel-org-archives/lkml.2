Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1FIB3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:29:46 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22000 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab1FIB3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:29:45 -0400
Message-ID: <4DF02207.3010108@dsn.okisemi.com>
Date: Thu, 09 Jun 2011 10:29:43 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
References: <4DEDBE90.3090305@dsn.okisemi.com> <20110607172211.GF17754@ponder.secretlab.ca> <4DEEDEA1.6070200@dsn.okisemi.com> <20110608145716.GC8499@ponder.secretlab.ca>
In-Reply-To: <20110608145716.GC8499@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 23:57), Grant Likely wrote:
> Ah, I understand what you're asking.
>
> Sorry, but I cannot pickup this patch for the stable series.  It is a
> new feature, not a bug fix.  Only bug fixes should be going into the
> stable kernel series.
>

My request didn't mean like above.
I meant that I want you to add the patch to next version linux, namely "3.1"
Because "irq_chip_generic" is implemented only RC version, namely "3.0-rcX"

Anyway, I don't think you change your opinion.
Thus, I must re-coding using "irq_chip_generic".

Thanks,
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
