Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1FGGAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:00:52 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26835 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab1FGGAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:00:50 -0400
Message-ID: <4DEDBE90.3090305@dsn.okisemi.com>
Date: Tue, 07 Jun 2011 15:00:48 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
CC: qi.wang@intel.com, yong.y.wang@intel.com, toshiharu-linux@dsn.okisemi.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com
Subject: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Let me resend again.
I haven't received your answer the following my question yet.

On Friday, May 27, 2011 4:09 PM, Grant Likely wrote:
> Take a look at the new irq_chip_generic infrastructure.  You don't
> need to implement a memory mapped irq controller from scratch anymore.
> Most of the access functions can be taken directly from
> irq_chip_generic instead.

Let me clarify your saying.
  a) We shouldn't use request_irq( ) ?
  b) Does Your  "irq_chip_generic" mean irq_set_handler_data( ) /
irq_set_chained_handler( ) ?
      If yes, Using these functions, I saw IRQ shared other function's
interrupt becomes invalid.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
