Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0JVBmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:42:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58193 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0JVBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:42:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH v5] Add generic exponentially weighted moving average (EWMA) function
Cc: kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com
In-Reply-To: <20101022013214.6831.25967.stgit@localhost6.localdomain6>
References: <20101022013214.6831.25967.stgit@localhost6.localdomain6>
Message-Id: <20101022104057.53B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Oct 2010 10:42:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only one nit.

> +/**
> + * ewma_init() - Initialize EWMA parameters
> + * @avg: Average structure
> + * @factor: Factor to use for the scaled up internal value. The maximum value
> + *	of averages can be UINT_MAX/(factor*weight).

			ULONG_MAX?


Anyway,
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




