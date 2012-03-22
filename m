Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031500Ab2CVXRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:17:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031470Ab2CVXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:17:36 -0400
Date: Thu, 22 Mar 2012 16:17:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Gross <jesse@nicira.com>
Cc: linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@nicira.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Justin Pettit <jpettit@nicira.com>
Subject: Re: [PATCH] proc-ns: Use d_set_d_op() API to set dentry ops in
 proc_ns_instantiate().
Message-Id: <20120322161734.2a22f3ba.akpm@linux-foundation.org>
In-Reply-To: <1331690897-26496-1-git-send-email-jesse@nicira.com>
References: <1331690897-26496-1-git-send-email-jesse@nicira.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 19:08:17 -0700
Jesse Gross <jesse@nicira.com> wrote:

> From: Pravin B Shelar <pshelar@nicira.com>
> 
> Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes ns
> cleanup path i.e. `ip netns delete `.
> 
> This issue exists back to 3.0.

What does "fixes" mean?  Please provide a full description of the
user-visible impact of the bug, so that others can ascertain whether
the patch will fix a problem which they're seeing and so that people
like me can work out which kernel versions we should merge it into.

Thanks.

