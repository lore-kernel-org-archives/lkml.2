Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1FYQfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 12:35:19 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:33896 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab1FYQfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 12:35:17 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de
Subject: [PATCH v3 00/11] OLPC Power Management
Date: Sat, 25 Jun 2011 17:34:07 +0100
Message-Id: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=8BAPIw8Zk9oA:10 a=vJ1w_8FsMGIA:10 a=hvfQPvgnvra5oIDOilcA:9 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches implement various power management and system-level features
on the XO-1 and XO-1.5 laptops.

v2: add Acked-bys, add a code comment in response to review

v3: fix depends/select on MFD and CS5535 GPIO (from Andres)

Andrew, we're having trouble getting movement on these patches, would you
mind taking a quick look at them and maybe putting them in your tree?

Review comments very welcome, I'll do my best to act upon them quickly.

Thanks,
Daniel


