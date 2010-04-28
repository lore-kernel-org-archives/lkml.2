Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0D1Bjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:39:55 -0400
Received: from ozlabs.org ([203.10.76.45]:58080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0D1Bjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:39:52 -0400
Date: Wed, 28 Apr 2010 11:39:51 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: David Miller <davem@davemloft.net>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 00/11] jump label v7
Message-ID: <20100428013951.GM12389@ozlabs.org>
Mail-Followup-To: David Miller <davem@davemloft.net>, jbaron@redhat.com,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
	rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
	rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
	avi@redhat.com, vgoyal@redhat.com
References: <cover.1271427118.git.jbaron@redhat.com>
 <20100422.161700.191166551.davem@davemloft.net>
 <20100427.175858.134109609.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100427.175858.134109609.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 05:58:58PM -0700, David Miller wrote:

> The kernel stops compiling after the second patch because
> kernel/jump_label.c is compiled unconditionally, and this generates an
> attempt to include asm/alternatives.h which is an x86-only phenomenon.
> 
> Do you have access to a cross-compile environment or at least some
> non-x86 system you can test build on before submitting these patch
> sets?

I heard cross-compilers?

http://kernel.org/pub/tools/crosstool/files/bin/  i686 and x86_64 and 4.4.0
compilers suitable for kernel work.

I plan to build 4.4.$latest and 4.5.0 ASAP.

Yours Tony
