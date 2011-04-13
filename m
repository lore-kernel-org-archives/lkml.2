Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1DMPBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:01:43 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54126 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756788Ab1DMPBm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:01:42 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Apr 2011 07:59:29 -0700
Subject: [PATCH 0/13] mfd: update 88pm860x and max8925
Thread-Topic: [PATCH 0/13] mfd: update 88pm860x and max8925
Thread-Index: Acv562Opqr42/tQ3RDy7XMqmdFm3Lw==
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CEF91F35@SC-VEXCH1.marvell.com>
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

Changelog:
	1. Replace mfd_data with platform_data for 88pm860x since mfd tree is upgraded
	2. fix warning for 88pm860x
	3. Update max8925

Thanks
Haojian
