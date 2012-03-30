Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2C3F4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:56:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43758 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2C3Fz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:55:57 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-24-4f754aeb3435
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1332130930.26765.2.camel@phoenix>
In-reply-to: <1332130930.26765.2.camel@phoenix>
Subject: RE: [PATCH RESEND 1/4] regulator: Fix setting new voltage in
 s5m8767_set_voltage
Date: Fri, 30 Mar 2012 14:56:10 +0900
Message-id: <03f801cd0e39$cec0d0c0$6c427240$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0Fh/Ok60trTR7hTEahgDgzKLfbcgIqchgw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:22 AM, Axel Lin wrote:
> Current code does not really update the register with new value, fix it.
> I rename the variable i to sel for better readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks for your fixing patch.
Sangbeom.

