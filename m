Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2HGRo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:26 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35543 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2HGRoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:25 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v0 0/12] x86, microcode, AMD: Per-family patches cache
Date: Tue,  7 Aug 2012 19:44:09 +0200
Message-Id: <1344361461-10076-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here's a set of patches which adds code for caching all microcode
patches which belong to the current family on which we're running. We
look up the patch needed for each core from the cache at application
time instead of holding a single patch per-system.

Also, each commit message should contain additional, hopefully sensible
information about each change.

Patchset has been tested on all families which are supported by the
microcode loader ( >= 0x10).

As always, all comments and suggestions are appreciated.

Thanks.
