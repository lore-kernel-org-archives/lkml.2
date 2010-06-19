Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0FSI6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:58:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab0FSI6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:58:51 -0400
Date: Sat, 19 Jun 2010 10:58:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: hugh.dickins@tiscali.co.uk, ieidus@redhat.com,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
Message-ID: <20100619085849.GD18946@basil.fritz.box>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +.IR len .
> +The KSM daemon
> +.RI ( ksmd )

You should probably make clear it's a kernel thread, not a classic
daemon.

> +periodically scans those areas of user memory that have
> +been marked as mergeable,
> +looking for pages with identical content.

Overall it seems like an internal implementation detail.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
