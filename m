Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2EPFMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:12:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36669 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966201Ab2EPFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:12:07 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-5d-4fb33720fc73
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Kristoffer Ericson'" <kristoffer.ericson@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 5/7] backlight: jornada720: use pr_err/info instead of printk
Date: Wed, 16 May 2012 14:12:00 +0900
Message-id: <002301cd3322$6c640010$452c0030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zImxKO9q4db+7S8SyAPR98GQG5g==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



