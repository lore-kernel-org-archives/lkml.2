Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030600Ab2HWSsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:48:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2HWSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:48:00 -0400
Date: Thu, 23 Aug 2012 20:47:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        John Reiser <jreiser@bitwagon.com>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/4] ftrace: Make recordmcount.c handle __fentry__
Message-ID: <20120823184754.GR16230@one.firstfloor.org>
References: <20120823181537.510961094@goodmis.org> <20120823181659.148123912@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823181659.148123912@goodmis.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I did a quick read of the patches and they all look good to me.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
