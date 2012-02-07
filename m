Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2BGJMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:12:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62536 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2BGJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:12:18 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-23-4f30eaf11225
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
References: <1328528127-20771-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1328528127-20771-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] regulator: s5m8767: Fix unused variable warning in probe()
Date: Tue, 07 Feb 2012 18:12:13 +0900
Message-id: <071701cce578$94a46620$bded3260$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Aczkw2+ox5UR9cTZTlGxLqRnUeyOSgAtN/fg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 06, 2012 8:35 PM, Mark Brown wrote:

> Subject: [PATCH] regulator: s5m8767: Fix unused variable warning in
probe()
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/s5m8767.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
Acked-by: Sangbeom Kim <sbkim73@samsung.com>

