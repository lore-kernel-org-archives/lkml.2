Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2JCG2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:28:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2JCG2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:28:36 -0400
Date: Tue, 2 Oct 2012 23:28:33 -0700 (PDT)
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/10] compiler-gcc4.h: Reorder macros based upon gcc
 ver
In-Reply-To: <1348874411-28288-3-git-send-email-daniel.santos@pobox.com>
Message-ID: <alpine.DEB.2.00.1210022328220.12717@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-3-git-send-email-daniel.santos@pobox.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Daniel Santos wrote:

> This helps to keep the file from getting confusing, removes one
> duplicate version check and should encourage future editors to put new
> macros where they belong.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

Acked-by: David Rientjes <rientjes@google.com>
