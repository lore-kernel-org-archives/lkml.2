Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0ESHTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:19:06 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38322 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0ESHTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=etU+PxR3NhzElx9YCX8b30EMKFjwYqlyP0aWcvmganS74RRMPj1awKU/z3o/M14bFA
         KWGTiMDCToXbKSAmhlrAPl3G0g/oW4YqrqQVC57mTb11DUI1U+7fe0fP6ODoE8/D1+Me
         1nffaRIUOZdwwPw6TyIHxrbDGK8K+iNYUHDLY=
Date: Wed, 19 May 2010 09:19:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Disallow mmap() on per-task inherited events
Message-ID: <20100519071906.GB5704@nowhere>
References: <20100518133258.000434886@chello.nl> <20100518133725.885757039@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133725.885757039@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:32:59PM +0200, Peter Zijlstra wrote:
> Since we now have working per-task-per-cpu events for a while,
> disallow mmap() on per-task inherited events. Those things were
> a performance problem anyway, and doing away with it allows
> us to optimize the buffer somewhat by assuming there is only a single
> writer.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---



That is a very good news.

