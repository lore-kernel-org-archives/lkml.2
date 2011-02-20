Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1BTNJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:09:44 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59168 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113Ab1BTNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:09:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18MkcgjOLcMOTEfbSiRVHWf0kjhv2OLEmVthnQVBS
	vZO64PKfIDgFB0
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Feb 2011 14:09:39 +0100
Message-ID: <1298207379.7998.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 15:08 +0800, Yong Zhang wrote:
> Now enable/disable autogroup at runtime is just a flag,
> it doesn't take effect on current process of the system.

Yup, they only move upon migration, which can take up to forever.  Linus
didn't like the idea of an active on/off switch, so it got whacked.

	-Mike

