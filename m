Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0FHE5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:57:05 -0400
Received: from ozlabs.org ([203.10.76.45]:55332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0FHE5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:57:03 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>
From: Michael Neuling <mikey@neuling.org>
Date: Tue, 08 Jun 2010 14:57:02 +1000
Subject: [PATCH 0/3] sched: asymmetrical packing for POWER7 SMT4
Message-Id: <1275973022.91203.586435002889.qpush@pale>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements asymmetric SMT packing which ensures
consistently good performance on POWER7.  Without this series, tasks
will vary in performance by around +/-30% on POWER7

This new version is based on help from Vatsa and Vaidy in an attempt
to answer concerns that Peter Zijlstra had about the original series.

The 1st patch is a fix for SMT4 in general.
The 2nd adds actual the asymmetrical packing infrastructure.  
The 3rd adds the powerpc specific hooks for POWER7.
