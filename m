Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab0DIVoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:44:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0DIVoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:44:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
In-Reply-To: Oleg Nesterov's message of  Monday, 29 March 2010 13:40:46 +0200 <20100329114046.GB16971@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
	<20100329114046.GB16971@redhat.com>
X-Windows: a mistake carried out to perfection.
Message-Id: <20100409214337.84F50D0BF@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 14:43:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
