Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1AGI4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:56:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59264 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1AGI4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:56:36 -0500
Subject: Re: [PATCH] sched: remove root_task_group
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
References: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 09:57:01 +0100
Message-ID: <1294390621.2016.390.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:43 +0800, Yong Zhang wrote:
> root_task_group is the leftover of USER_SCHED, now it's always
> same to init_task_group.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org> 

Thanks!
