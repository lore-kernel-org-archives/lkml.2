Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457Ab2HPUMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:12:38 -0400
Received: from tex.lwn.net ([70.33.254.29]:44369 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030365Ab2HPUMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:12:35 -0400
Date: Thu, 16 Aug 2012 14:12:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120816141253.0142ddd0@lwn.net>
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012 19:45:19 +0200
Borislav Petkov <bp@amd64.org> wrote:

> off and on I get some free time to work on that, here's the latest
> incarnation. It contains review feedback from the earlier round.

Can I add one small request for the next round?  I've looked through the
patches and the code a bit, and I still have absolutely no clue of what a
"persistent event" is or why I might want one.  Now, admittedly, I'm
slower than most, but it still might not hurt to add some overall
description of what this is for...?

Thanks,

jon
