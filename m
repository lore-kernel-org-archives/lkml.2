Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0ENCHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:07:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56761 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0ENCHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:07:10 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 3/4] ftrace syscalls: Allow arch specific syscall symbol matching
From: Ian Munsie <imunsie@au1.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-reply-to: <1273794896.21352.203.camel@pasglop>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com> <1273736594-19320-4-git-send-email-imunsie@au1.ibm.com> <1273794896.21352.203.camel@pasglop>
Date: Fri, 14 May 2010 12:06:41 +1000
Message-Id: <1273802608-sup-8186@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Benjamin Herrenschmidt's message of Fri May 14 09:54:56 +1000 2010:
> On Thu, 2010-05-13 at 17:43 +1000, Ian Munsie wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > Some architectures have unusual symbol names and the generic code to
> > match the symbol name with the function name for the syscall metadata
> > will fail. For example, symbols on PPC64 start with a period and the
> > generic code will fail to match them.
> > 
> > This patch splits out the match logic into a standalone weak function
> > that can be overridden on archs with unusual symbol names.
> > 
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > ---
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Ian, I assume you will implement the support for the "special" ppc_*
> syscalls via a subsequent patch and not a respin of this one right ?
> 
> Cheers,
> Ben.

Yes, that will be in a separate patch or two.

Cheers,
-Ian
