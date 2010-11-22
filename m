Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0KVC0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:26:25 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6576 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab0KVC0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:26:24 -0500
Message-ID: <00b201cb89ec$a7fa3170$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <wg@grandegger.com>, <w.sang@pengutronix.de>, <chripell@fsfe.org>,
        <21cnbao@gmail.com>, <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <margie.foster@intel.com>
References: <4CE9C6A4.1090809@dsn.okisemi.com> <20101121.180535.193735538.davem@davemloft.net>
Subject: Re: [PATCH net-next-2.6 7/17 v2] can: EG20T PCH: Modify function/macro name/type
Date: Mon, 22 Nov 2010 11:26:19 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

My previous v2 two patches don't influence subsequent patches.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <tomoya-linux@dsn.okisemi.com>
Cc: <wg@grandegger.com>; <w.sang@pengutronix.de>; <chripell@fsfe.org>; <21cnbao@gmail.com>; <sameo@linux.intel.com>;
<socketcan-core@lists.berlios.de>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <qi.wang@intel.com>;
<yong.y.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <joel.clark@intel.com>; <kok.howg.ewe@intel.com>;
<margie.foster@intel.com>
Sent: Monday, November 22, 2010 11:05 AM
Subject: Re: [PATCH net-next-2.6 7/17 v2] can: EG20T PCH: Modify function/macro name/type


>
> In case it isn't clear, you need to resubmit this entire
> patch series after you've integrated all of our feedback.
>
> It doesn't make sense to just resubmit specific pieces
> that you fix, because each change you make causes
> subsequent patches in the series to no longer apply
> cleanly.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

