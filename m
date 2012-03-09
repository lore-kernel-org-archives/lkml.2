Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2CIC3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:29:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10174 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2CIC3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:29:01 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-2a-4f596aebaa46
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1331093522.3143.3.camel@phoenix>
In-reply-to: <1331093522.3143.3.camel@phoenix>
Subject: RE: [PATCH] regulator: Rename s5m8767_convert_voltage to
 s5m8767_get_proper_voltage_sel
Date: Fri, 09 Mar 2012 11:28:59 +0900
Message-id: <069e01ccfd9c$62b5f840$2821e8c0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz8GHnQ+X7MKM28QxaDJ7fofCMmfgBfAFow
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday, Mar 07, 2012 at 1:12AM, Axel Lin wrote:
> -static inline int s5m8767_convert_voltage(
> +static int s5m8767_get_proper_voltage_sel(

s5m8767_get_voltage_sel and s5m8767_get_proper_voltage_sel 
have confusion too.
Except that, Looks OK.

Thanks,

