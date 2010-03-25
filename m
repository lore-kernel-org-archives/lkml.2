Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0CYN4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:56:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0CYN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:56:00 -0400
Message-Id: <20100325135148.626077692@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 25 Mar 2010 14:51:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix ptrace debugctlmsr stomping and kill ptrace-bts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace was stomping all over debugctlmsr and since ptrace-bts was never used
kill that and reimplement ptrace block-step to not trample on the msr.

