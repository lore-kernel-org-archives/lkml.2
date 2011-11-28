Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1K1APo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:15:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:43694 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab1K1APn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:15:43 -0500
Message-ID: <1322439281.23348.34.camel@pasglop>
Subject: Re: [PATCH v9 11/13] powerpc: select HAVE_SECCOMP_FILTER and
 provide seccomp_execve
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Drewry <wad@chromium.org>
Cc: linuxppc-dev@lists.ozlabs.org, fweisbec@gmail.com, scarybeasts@gmail.com,
        djm@mindrot.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        segoon@openwall.com, tglx@linutronix.de,
        Paul Mackerras <paulus@samba.org>, kees.cook@canonical.com,
        jmorris@namei.org, torvalds@linux-foundation.org, mingo@elte.hu
Date: Mon, 28 Nov 2011 11:14:41 +1100
In-Reply-To: <1314682083.2488.73.camel@pasglop>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	 <1308875813-20122-11-git-send-email-wad@chromium.org>
	 <1314682083.2488.73.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 15:28 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-06-23 at 19:36 -0500, Will Drewry wrote:
> > Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
> > system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
> > 
> > v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
> > 
> > Signed-off-by: Will Drewry <wad@chromium.org>
> 
> Seen these around for a while ... :-)
> 
> I don't see a harm in the patches per-se tho I haven't reviewed the
> actual seccomp filter stuff and it's good (or bad) behaviour on ppc.

Did that stuff every got anywhere ? I don't see HAVE_SECCOMP_FILTER
upsteam ... should I just drop the powerpc patch from patchwork ?

Cheers,
Ben.


