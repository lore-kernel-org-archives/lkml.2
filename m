Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1FZVwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:52:05 -0400
Received: from vostochny.stro.at ([78.47.22.85]:55156 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1FZVu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:50:59 -0400
Date: Sun, 26 Jun 2011 21:50:57 +0000
From: maximilian attems <max@stro.at>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc4: Reported regressions from 2.6.39
Message-ID: <20110626215057.GC23371@vostochny.stro.at>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 11:18:39PM +0200, Rafael J. Wysocki wrote:
>   2011-06-26       22       14          12
>   2011-06-12        8        7           7
> 
> 
> Unresolved regressions
> ----------------------
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37562
> Subject		: /scripts/depmod.sh ends up -rw-r--r-- 1 depmod.sh
> Submitter	: Andrew <atswartz@gmail.com>
> Date		: 2011-06-15 23:49 (12 days old)

this is fixed thanks to linux-kbuild pull in 3.0-rc4
569658dddf276ceb0780776e7f5d61d9f8d8cb88
 
 
-- 
maks
