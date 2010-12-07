Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab0LGFGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:06:23 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42500 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0LGFGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:06:21 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-doc <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall symbol matching
From: Ian Munsie <imunsie@au1.ibm.com>
To: Mike Frysinger <vapier@gentoo.org>
In-reply-to: <AANLkTik7O=xVP2WuD+AV-oQqg9heT4fVbEa65W+BRq11@mail.gmail.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com> <1291696151-4336-5-git-send-email-imunsie@au1.ibm.com> <AANLkTik7O=xVP2WuD+AV-oQqg9heT4fVbEa65W+BRq11@mail.gmail.com>
Date: Tue, 07 Dec 2010 16:06:18 +1100
Message-Id: <1291698267-sup-2037@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Mike Frysinger's message of Tue Dec 07 15:56:49 +1100 2010:
> useless set of parenthesis, and this overhead sucks.  weak +
> additional function call just for a strcmp for most people ?  why not
> make it into a define in the header:
> #ifndef arch_syscall_match_sym_name
> #define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name + 3)
> #endif
> -mike

No problem, will change it.

Cheers,
-Ian
