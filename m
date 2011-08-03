Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1HCDhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 23:37:41 -0400
Received: from linux-sh.org ([111.68.239.195]:48326 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1HCDhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 23:37:34 -0400
Date: Wed, 3 Aug 2011 12:37:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Fix conflicting definitions of ptrace_triggered
Message-ID: <20110803033732.GD32513@linux-sh.org>
References: <1312148195-32658-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312148195-32658-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 05:36:35PM -0400, Paul Gortmaker wrote:
> The extra nmi argument is causing this compile fail:
> 
>   CC      arch/sh/kernel/ptrace_32.o
> arch/sh/kernel/ptrace_32.c:66:6: error: conflicting types for 'ptrace_triggered'
> arch/sh/include/asm/ptrace.h:126:13: note: previous declaration of 'ptrace_triggered' was here
> make[3]: *** [arch/sh/kernel/ptrace_32.o] Error 1
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
Applied, thanks.
