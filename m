Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0EWSP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:15:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0EWSP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:15:26 -0400
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1274554806-28216-2-git-send-email-bp@alien8.de>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
	 <1274554806-28216-2-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 20:15:13 +0200
Message-ID: <1274638513.1674.1727.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 21:00 +0200, Borislav Petkov wrote:
> Register and enable events marked as persistent right after perf events
> has initialized.
> 
> Not-yet-signed-off-by: Borislav Petkov <bp@alien8.de>

Nah, this is totally wrong.

A persistent event would simply be a regular event, but created by the
kernel and not tied to a file-desc's lifetime.



