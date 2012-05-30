Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2E3FdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:33:04 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:53458 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174Ab2E3FdC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:33:02 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Arun MURTHY <arun.murthy@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>
Date: Wed, 30 May 2012 07:32:10 +0200
Subject: RE: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Thread-Topic: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Thread-Index: Ac03L+QfWkxkRi/ATYmo+uJ+FAxqnAG9YPug
Message-ID: <F45880696056844FA6A73F415B568C69595AD0E365@EXDCVYMBSTM006.EQ1STM.local>
References: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Force the Modem wakeup by asserting the CaWakeReq signal before the
> hostaccess_req/ack ping-pong sequence. The Awake_req signal is de-
> asserted
> asserted at the same time than the hostaccess_req. Return error on
> failure
> case so that the client using this can take appropiate steps.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---


Any Comments?

Thanks and Regards,
Arun R Murthy
-------------
