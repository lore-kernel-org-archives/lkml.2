Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0KIM1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:27:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:40653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab0KIM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:27:13 -0500
Date: Tue, 9 Nov 2010 04:27:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Message-ID: <20101109042747.3f6ab07b@infradead.org>
In-Reply-To: <1289304672.6287.132.camel@dan>
References: <1289273338.6287.128.camel@dan>
	<20101109112350.GA29800@elte.hu>
	<1289304672.6287.132.camel@dan>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 07:11:12 -0500
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> 
> > 
> > The initialization to zero is implicit, no need to write it out.
> > 
> 
> I'll resend after the first round of comments.
> 
> > Also, it would also be useful to have a
> > CONFIG_SECURITY_RESTRICT_DMESG=y option introduced by your patch as
> > well, which flag allows a distro or user to disable unprivileged
> > syslog reading via the kernel config.
> 
> Are you suggesting having the existence of the sysctl depend on
> CONFIG_SECURITY_RESTRICT_DMESG, or having a choice between a sysctl
> (when config is disabled) and having restrictions always on (when
> config is enabled)?

and/or have the sysctl default value depend on the config option


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
