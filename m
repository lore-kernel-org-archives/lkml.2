Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1HXG6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:58:52 -0400
Received: from ozlabs.org ([203.10.76.45]:44367 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab1HXG6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:49 -0400
X-Mailbox-Line: From anton@samba.org Wed Aug 24 16:52:42 2011
Message-Id: <20110824064013.205515988@samba.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Aug 2011 16:40:13 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] perf symbol fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix some bugs in our symbol code and adds
heuristics to select which duplicate symbol to use.

In the process this fixes the issue on ppc where we need to handle both
the old style and new style 64bit ABI.

Anton

