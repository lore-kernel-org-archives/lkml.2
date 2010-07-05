Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0GEJfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:35:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39190 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0GEJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :user-agent;
        b=xC5yM4r19KeQJU03aiA6Lu42H5QN0nNfmFAbcqPpUnp7QSurjWKi0cC/OoFO51DJkC
         y7WoxgCqhbBDOU8DHVeupyG5LJU2bINNF3isH+23qbm304bUNGYNf+D//TlGS87mJnZ0
         k2pdac8bSIGTEwmraFI0i1h7Qd/m6+Y5TqMTI=
Date: Mon, 05 Jul 2010 09:28:42 +0000
From: Ali Gholami Rudi <ali@rudi.ir>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
Message-ID: <20100507092842@tarekhel>
In-Reply-To: <4C319D61.5090002@redhat.com>
References: <20100507075128@tarekhel>
	<4C319D61.5090002@redhat.com>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng <dfeng@redhat.com> wrote:
> Could you please try following commit in -tip tree?
> 
> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Sat May 29 15:31:43 2010 +0200
> 
>      rbtree: Undo augmented trees performance damage

Where can I get it?  I couldn't find it either in
Linus' or x86 repo tip.

Thanks,
Ali

