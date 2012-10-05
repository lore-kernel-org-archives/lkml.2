Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2JEU1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:27:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:27:09 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2J33qrD0vuwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=L2-w0YjVfU4A:10 a=HZJGGiqLAAAA:8 a=M20DLZ1KUW9T_0-4cnsA:9 a=PUjeQqilurYA:10 a=HeoGohOdMD0A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349468825.6755.67.camel@gandalf.local.home>
Subject: Re: [PATCH v2 0/10] Cleanup & new features for compiler*.h and bug.h
From: Steven Rostedt <rostedt@goodmis.org>
To: danielfsantos@att.net
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 05 Oct 2012 16:27:05 -0400
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
	 <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 14:35 -0500, danielfsantos@att.net wrote:
> This patch set is a dependency of the generic red-black tree patch set, which
> I have now split up into three smaller sets.
> 
> The major aim of this patch set is to cleanup compiler-gcc*.h and improve the
> manageability of of compiler features at various versions (when they are
> broken, etc.), and to cleanup & add some needed features to bug.h.
> 

A quick review of the patches look fine to me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


