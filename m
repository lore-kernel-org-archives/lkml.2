Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1HWGFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:05:10 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35047 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HWGFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:05:07 -0400
Date: Tue, 23 Aug 2011 08:04:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 26/43] [S390]: Use block_sigmask()
Message-ID: <20110823080451.7acdaa71@mschwide>
In-Reply-To: <1313772419-21951-27-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	<1313772419-21951-27-git-send-email-matt@console-pimps.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 17:46:42 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> Use the new helper function block_sigmask() which centralises the code
> for updating current->blocked after successfully delivering a signal
> and reduces the amount of duplicate code across architectures.
> 
> In the past some architectures got this code wrong, so using this
> helper function should stop that from happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
> 
> This patch depends on "[PATCH 01/43] signal: Add block_sigmask() for
> adding sigmask to current->blocked" so they need to go through the
> same tree but this patch would benefit from some maintainer ACK's.
> 
>  arch/s390/kernel/compat_signal.c |    6 +-----
>  arch/s390/kernel/signal.c        |    6 +-----
>  2 files changed, 2 insertions(+), 10 deletions(-)

Identical code replacement and compiles fine.
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

