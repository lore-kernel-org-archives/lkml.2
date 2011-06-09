Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1FIJOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:14:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1FIJN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:13:56 -0400
Subject: Re: [GIT PULL] perf update
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
In-Reply-To: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
References: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jun 2011 11:13:33 +0200
Message-ID: <1307610813.3941.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 16:56 +0200, Frederic Weisbecker wrote:

> Frederic Weisbecker (1):
>       perf: Split up buffer handling from core code
> 
> 
>  kernel/events/Makefile   |    2 +-
>  kernel/events/buffer.c   |  400 ++++++++++++++++++++++++++++++++++++++++
>  kernel/events/core.c     |  458 ++--------------------------------------------
>  kernel/events/internal.h |   70 +++++++
>  4 files changed, 487 insertions(+), 443 deletions(-)

Looks about right.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
