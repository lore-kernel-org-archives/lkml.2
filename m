Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2JCGZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:25:18 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58394 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2JCGZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:25:15 -0400
Date: Tue, 2 Oct 2012 23:25:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Santos <daniel.santos@pobox.com>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/10] compiler-gcc4.h: correct verion check for
 __compiletime_error
In-Reply-To: <1348874411-28288-2-git-send-email-daniel.santos@pobox.com>
Message-ID: <alpine.DEB.2.00.1210022324430.12717@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-2-git-send-email-daniel.santos@pobox.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Daniel Santos wrote:

> NOTE: this is has already been comitted to -mm
> 
> __attribute__((error(msg))) was introduced in gcc 4.3 (not 4.4) and as I
> was unable to find any gcc bugs pertaining to it, I'm presuming that it
> has functioned as advertised since 4.3.0.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Tested-by: David Rientjes <rientjes@google.com>

Works with 4.3.6.
