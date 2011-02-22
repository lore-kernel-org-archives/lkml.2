Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1BVJ4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:56:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:38961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1BVJ4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:56:11 -0500
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	 <1298207379.7998.11.camel@marge.simson.net> <20110220141003.GA6006@zhy>
	 <1298222533.7881.15.camel@marge.simson.net>
	 <1298306175.24121.14.camel@twins>
	 <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Feb 2011 10:56:06 +0100
Message-ID: <1298368566.2217.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 11:13 +0800, Yong Zhang wrote:
> So show autogroup name always. But for the root group,
> its name will dance between "cfs_rq[cpu]:" and
> "cfs_rq[cpu]:/autogroup-0" according to
> sysctl_sched_autogroup_enabled. 

Would it make sense to force the root group to always be a !autogroup?
