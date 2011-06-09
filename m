Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1FIUQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:16:18 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:9720 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574Ab1FIUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:16:17 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de
Subject: [PATCH v2 00/11] OLPC Power Management
Date: Thu,  9 Jun 2011 21:05:25 +0100
Message-Id: <1307649936-23655-1-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.2
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=8AFdskE8yxcA:10 a=vJ1w_8FsMGIA:10 a=hvfQPvgnvra5oIDOilcA:9 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches implement various power management and system-level features
on the XO-1 and XO-1.5 laptops.

The only change since the original submission are some new Acked-by's and
a code comment added in response to one of the review emails.

Andrew, we're having trouble getting movement on these patches, would you
mind taking a quick look at them and maybe putting them in your tree?

Review comments very welcome, I'll do my best to act upon them quickly.

Thanks,
Daniel

