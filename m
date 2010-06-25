Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0FYBLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 21:11:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49707 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0FYBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 21:11:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v2 2/5] napi: convert trace_napi_poll to TRACE_EVENT
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com
In-Reply-To: <4C23FF28.4040404@jp.fujitsu.com>
References: <4C2312A8.9060903@jp.fujitsu.com> <4C23FF28.4040404@jp.fujitsu.com>
Message-Id: <20100625101056.8039.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 10:11:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch converts trace_napi_poll from DECLARE_EVENT to TRACE_EVENT.
> This lets you know how long napi_poll takes.
> 
>           <idle>-0     [001] 241302.750777: napi_poll: napi poll on napi struct f6acc480 for device eth3
>           <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d70c for device eth1
>           <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d20c for device eth1
> 
> This is a same patch Neil Horman submitted.
> http://marc.info/?l=linux-kernel&m=125978157926853&w=2

Ditto.
Please don't remove Neil's S-O-B.



