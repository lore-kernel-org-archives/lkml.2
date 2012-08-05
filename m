Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2HEMRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 08:17:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59764 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2HEMRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 08:17:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 5 Aug 2012 14:15:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: new section mismatch: uncore_types_exit() refers to
 .init.text:uncore_type_exit()
Message-ID: <20120805141554.6a134747@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously added by 14371cce03c2fc393997e17f979e76674b7f392a:

WARNING: vmlinux.o(.text+0x13831): Section mismatch in reference from the function uncore_types_exit() to the function .init.text:uncore_type_exit()
The function uncore_types_exit() references
the function __init uncore_type_exit().
This is often because uncore_types_exit lacks a __init 
annotation or the annotation of uncore_type_exit is wrong.

HTH,
-- 
Stefan Richter
-=====-===-- =--- --=-=
http://arcgraph.de/sr/
