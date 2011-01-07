Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1AGI4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:56:54 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59345 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1AGI4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:56:53 -0500
Subject: Re: [PATCH] sched: mark autogroup_init() __init
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
References: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 09:57:18 +0100
Message-ID: <1294390638.2016.391.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:43 +0800, Yong Zhang wrote:
> autogroup_init() is only called at boot time.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>=

Thanks
