Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2HQBJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:09:08 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:36638 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab2HQBJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:09:07 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <52263.162.105.80.111.1345165790.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1345129523-1967-1-git-send-email-tklauser@distanz.ch>
References: <1345129523-1967-1-git-send-email-tklauser@distanz.ch>
Date: Fri, 17 Aug 2012 09:09:50 +0800 (CST)
Subject: Re: [PATCH] unicore32: Use schedule_preempt_disabled()
To: "Tobias Klauser" <tklauser@distanz.ch>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Ingo Molnar" <mingo@elte.hu>
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Follow bd2f5536 (sched/rt: Use schedule_preempt_disabled()).
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Thanks.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>


