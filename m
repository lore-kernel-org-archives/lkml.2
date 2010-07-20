Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab0GTJMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:12:08 -0400
Received: from mail4.comsite.net ([205.238.176.238]:26761 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398Ab0GTJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:12:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=74.61.84.126;
From: Milton Miller <miltonm@bga.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: OOPS at boot time
In-Reply-To: <20100720164145.e06242b3.sfr@canb.auug.org.au>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
Date: Tue, 20 Jul 2010 04:12:04 -0500
X-Originating-IP: 74.61.84.126
Message-ID: <1279617124_23571@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Al,
> 
> All of my PowerPC boot tests are getting this after getting to user mode
> (sometimes several times):

> 
> This is:
> BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> in iput_final().
> 
> That BUG_ON was added by commit c0ae81f2 ("Make ->drop_inode() just
> return whether inode needs to be dropped").
> 
> Has anyone seen this or something similar?

http://kerneltrap.org/mailarchive/linux-kernel/2010/7/8/4591460/thread

Looks like it died due to unable to reproduce ...

I don't need to be cc'd.

milton
