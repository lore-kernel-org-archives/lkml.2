Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1LLLfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:35:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1LLLfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:35:04 -0500
Date: Mon, 12 Dec 2011 15:31:56 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH -next] proc: fix task_struct infoleak
Message-ID: <20111212113156.GA12141@albatros>
References: <20111211182821.GA2853@albatros>
 <20111211205939.GH2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111211205939.GH2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 20:59 +0000, Al Viro wrote:
> On Sun, Dec 11, 2011 at 10:28:21PM +0400, Vasiliy Kulikov wrote:
> > proc_pid_permission() doesn't put task_struct on every /proc/$pid/
> > access.  A demo from Hugh Dickins:
> > 
> > while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done
> > 
> > Reported-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> > ---
> >  This is a patch against a hidepid patchset from -mm.
> 
> Choose saner commit summary, please.  It's not information leak, for pity sake
> - it's a plain and simple memory leak...

Oops!  s/infoleak/memleak/ surely, bad habit...

Thank you, I'll resend the patch.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
