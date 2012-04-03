Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2DCFmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:42:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9159 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2DCFmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:42:17 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-f9-4f7a8db87b5e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1332130930.26765.2.camel@phoenix>
 <1332131078.26765.5.camel@phoenix>
In-reply-to: <1332131078.26765.5.camel@phoenix>
Subject: RE: [PATCH RFC 3/4] regulator: Use one s5m8767_ops for both LDOs and
 BUCKs
Date: Tue, 03 Apr 2012 14:42:16 +0900
Message-id: <01b001cd115c$86e60f60$94b22e20$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0FiEtDOsaCTYiRQyKGYw+tZnb15gL1BZuw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:25 PM, Axel Lin wrote:
> All the callback function implementation are the same for both LDOs and BUCKs.
> Merge them to one s5m8767_ops.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

