Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0DIUNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0DIUNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:13:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] proc: turn signal_struct->count into "int
	nr_threads"
In-Reply-To: Oleg Nesterov's message of  Wednesday, 24 March 2010 18:49:36 +0100 <20100324174936.GA21534@redhat.com>
References: <20100324174936.GA21534@redhat.com>
X-Shopping-List: (1) Heretical deception
   (2) Ludicrous L'eggs ponds
   (3) Fraudulent bum impositions
   (4) Boring expectorant witches
   (5) Frothy pronunciations
Message-Id: <20100409201339.09D3ED174@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 13:13:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

> It is a bit sad we need a word in struct signal_struct for this, perhaps
> we can change get_nr_threads() to approximate the number of threads using
> signal->live and kill ->nr_threads later.

Agreed.


Thanks,
Roland
