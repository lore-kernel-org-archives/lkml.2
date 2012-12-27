Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab2L0BwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:52:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2L0BwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:52:23 -0500
Date: Wed, 26 Dec 2012 17:52:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
In-Reply-To: <1356560399.7010.45.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.2.00.1212261748500.4150@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356511396.7010.13.camel@shinybook.infradead.org>
 <alpine.DEB.2.00.1212260228200.10166@chino.kir.corp.google.com> <1356525527.7010.34.camel@shinybook.infradead.org> <alpine.DEB.2.00.1212261343210.20193@chino.kir.corp.google.com> <1356560399.7010.45.camel@shinybook.infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012, David Woodhouse wrote:

> Thanks. I'll look into this. I presume it was *always* failing, but
> nobody happened to come across it because our test coverage of x86
> configs without CONFIG_64BIT wasn't particularly good?
> 

Purely for selfish reasons, 32-bit isn't interesting for me.  I'm sure 
they existed before, as you said, but only got exposed to be because "make 
randconfig" now allows such configurations.  I've added ARCH=x86_64 to my 
scripts.
