Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2CNEcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:32:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54145 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2CNEct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:32:49 -0400
X-AuditID: cbfee61b-b7c62ae000000989-1c-4f601f6ff085
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1331340182.18199.3.camel@phoenix>
In-reply-to: <1331340182.18199.3.camel@phoenix>
Subject: RE: [PATCH] regulator: s5m8767: Check pdata->buck[2|3|4]_gpiodvs
 earlier
Date: Wed, 14 Mar 2012 13:32:47 +0900
Message-id: <0a3401cd019b$81f024d0$85d06e70$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz+VsQ+JwSTCaA+Q7C8467bdi8cOwDQtesg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Saturday, 2012-03-010 at 9:43 AM, Axel Lin wrote:
> If we need to ensure only one of the buck[2|3|4]_gpiodvs can be specificed,
> check them earlier.

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Sangbeom.
Thanks,

