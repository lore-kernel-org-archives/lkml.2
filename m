Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab2CNIt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:49:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32001 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab2CNItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:49:23 -0400
X-AuditID: cbfee61b-b7c62ae000000989-14-4f605b92e89e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1331348383.3654.1.camel@phoenix>
In-reply-to: <1331348383.3654.1.camel@phoenix>
Subject: RE: [PATCH] regulator: Make s5m8767_get_voltage_register always return
 correct register
Date: Wed, 14 Mar 2012 17:49:21 +0900
Message-id: <0a5001cd01bf$59b46bb0$0d1d4310$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz+aeHJsBG4+oUTR1y+qHAgCEfYFADMabfQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, Mar 10, 2012 at 12:00PM, Axel Lin wrote:
> Check s5m8767->buck[2|3|4]_gpiodvs status in s5m8767_get_voltage_register
> and return correct register accordingly.

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

