Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab2EIEYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:24:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11250 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2EIEYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:24:12 -0400
X-AuditID: cbfee61a-b7b97ae000004342-09-4fa9f16bd7f4
Message-id: <4FA9F16D.9090106@samsung.com>
Date: Wed, 09 May 2012 13:24:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: I have question for supporting irq_domain of MAX8997
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,

I have a question about your following patch:
- https://lkml.org/lkml/2012/4/18/145

I am implementing extcon-max8997 device driver which support MUIC feature
of Maxim MAX8997 chip. It have irq handler for MUIC irq based on
irq_base in struct max8997_dev. I have plan to support irq_domain for
MAX8997 instead of previous
irq operation and will modify that extcon-max8997 use irq_domain method.

So, Do you have plan to support irq domain for MAX8997 irq?
If yes, I will implement other tasks to support irq_domain for Maxim
MAX77686.

Thank you,

Best Regards,
Chanwoo Choi
