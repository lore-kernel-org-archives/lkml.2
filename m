Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2FTLI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:08:59 -0400
Received: from mail.renton.name ([90.155.165.44]:34741 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2FTLI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:08:58 -0400
Date: Wed, 20 Jun 2012 15:08:41 +0400
From: Alexey Vlasov <renton@renton.name>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120620110841.GD31797@beaver>
References: <20120619185856.GC31797@beaver>
 <20120620123431.aff6e049.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120620123431.aff6e049.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:34:31PM +0900, Daisuke Nishimura wrote:
> 
> What does "cat /sys/fs/cgroup/.../apache/memory.move_charge_at_immigrate" show ?

Here I have zero.

By the way such a delay is not only in memory controller but also in
others - in cpu, blkio for example.

-- 
BRGDS. Alexey Vlasov.
