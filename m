Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab1E0I23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:28:29 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1307 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525Ab1E0I22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:28:28 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, <alexander.stein@systec-electronic.com>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1306472691-6055-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1306472691-6055-3-git-send-email-tomoya-linux@dsn.okisemi.com> <20110527070833.GA31953@ponder.secretlab.ca>
Subject: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
Date: Fri, 27 May 2011 17:28:25 +0900
Message-ID: <1AE0D718B2974BCBA409AF045602867F@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwcPOVyosqo6SUNR++MLrnk7wR24gACbbsw
In-Reply-To: <20110527070833.GA31953@ponder.secretlab.ca>
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Friday, May 27, 2011 4:09 PM, Grant Likely wrote:
> Take a look at the new irq_chip_generic infrastructure.  You 
> don't need to implement a memory mapped irq controller from 
> scratch anymore.
> Most of the access functions can be taken directly from 
> irq_chip_generic instead. 

Let me clarify your saying.
  a) We shouldn't use request_irq( ) ?
  b) Does Your  "irq_chip_generic" mean irq_set_handler_data( ) / irq_set_chained_handler( ) ?
      If yes, Using these functions, I saw IRQ shared other function's interrupt becomes invalid.

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

