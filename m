Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab0JFXlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:41:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:43711 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab0JFXlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:41:21 -0400
Date: Thu, 7 Oct 2010 10:41:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        rostedt@goodmis.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] security: add const to
 security_task_setscheduler()
In-Reply-To: <20101005095725.28C0.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LRH.2.00.1010071040380.17286@tundra.namei.org>
References: <201010012119.o91LJMwQ021365@imap1.linux-foundation.org> <alpine.LRH.2.00.1010050929340.28702@tundra.namei.org> <20101005095725.28C0.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, KOSAKI Motohiro wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 15 Oct 2010 04:21:18 +0900
> Subject: [PATCH] security: remove unused parameter from security_task_setscheduler()
> 
> All security modules shouldn't change sched_param parameter of
> security_task_setscheduler().  This is not only meaningless, but also
> make a harmful result if caller pass a static variable.
> 
> This patch remove policy and sched_param parameter from
> security_task_setscheduler() becuase none of security module is
> using it.
> 
> Cc: James Morris <jmorris@namei.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
