Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab1BYUq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:46:29 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:63864 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1BYUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:28 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH SPLIT 0/2] Cleanup asm-offsets.c(PAGE_SIZE_asm, PAGE_SHIFT_asm, THREAD_SIZE_asm)
Date: Fri, 25 Feb 2011 22:46:12 +0200
Message-Id: <1298666774-17646-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Fri, 25 Feb 2011 22:46:26 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split into separate x86 and mn10300 patches.
