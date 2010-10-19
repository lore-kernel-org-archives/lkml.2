Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0JSNzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:31 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43767 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0JSNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:23 -0400
Message-Id: <20101019134256.087045503@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:42:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/7] perf,x86: PEBS/BTS buffer allocation changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

Your PEBS/BTS buffer patch failed a .config dependent build, which on its own
was rather easy to fix, but Ingo objected to the size of the patch and asked me
to rewrite in smaller increments. This patch series is the result.

What do you think?

