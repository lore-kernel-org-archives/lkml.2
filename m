Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0FOBDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0FOBDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:03:52 -0400
Date: Mon, 14 Jun 2010 22:03:09 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] perf probe: add kernel source path option
Message-ID: <20100615010309.GA4217@ghostprotocols.net>
References: <1276543590-10486-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276543590-10486-1-git-send-email-chase.douglas@canonical.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 14, 2010 at 03:26:30PM -0400, Chase Douglas escreveu:
> The probe plugin requires access to the source code for some operations.
> The source code must be in the exact same location as specified by the
> DWARF tags, but sometimes the location is an absolute path that cannot
> be replicated by a normal user. This change adds the -s|--source option
> to allow the user to specify the root of the kernel source tree.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>

Thanks, I saw it but didn't manage to test it yet, will try probably
tomorrow.

- Arnaldo
