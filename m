Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab0C2NHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0C2NHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:07:11 -0400
Date: Mon, 29 Mar 2010 15:05:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: John Kacur <jkacur@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100329130526.GA23201@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com> <20100329114046.GB16971@redhat.com> <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, John Kacur wrote:
>
> So, just to be clear about this particular patch, who is queuing it up
> to send to Linus? Would that be you Oleg, as a ptrace maintainer?

Cough. I must admit, apart from "urgent" bugfixes the only way I know
is to send the patch to Andrew.

So I'd suggest to send this patch to akpm. Of course, if you wish I can
forward it, but doesn't matter.

Oleg.

