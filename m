Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2ALIge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:36:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52695 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2ALIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:36:30 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-d0-4f0e9b8ced71
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1326351429.3471.0.camel@phoenix> <1326351505.3471.2.camel@phoenix>
In-reply-to: <1326351505.3471.2.camel@phoenix>
Subject: RE: [PATCH 2/2] regulator: s5m8767: Remove redundant MODULE_ALIAS
Date: Thu, 12 Jan 2012 17:36:51 +0900
Message-id: <027101ccd105$54e00170$fea00450$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczQ95mjCrbMOF3mTcahDmZPEjHPzAADMkVQ
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 12, 2012 3:58 PM, Axel Lin wrote:

> The MODULE_DEVICE_TABLE will setup the modalias, thus adding
> a MODULE_ALIAS for an entry already in s5m8767_pmic_id is redundant.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.
 


