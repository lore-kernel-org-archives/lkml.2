Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2AOW7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:59:17 -0500
Received: from mail4.comsite.net ([205.238.176.238]:41810 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2AOW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:59:16 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=74.211.133.180;
To: Martin Nyhus <martin.nyhus@gmx.com>
From: Milton Miller <miltonm@bga.com>
Subject: [next] possible recursive locking in autofs4_write
In-Reply-To: <201201152248.37439.martin.nyhus@gmx.com>
References: <201201152248.37439.martin.nyhus@gmx.com>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 15 Jan 2012 16:59:12 -0600
X-Originating-IP: 74.211.133.180
Message-ID: <1326668352_245@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks like mutex_lock should have been mutex_unlock in commit d668dc56
> (autofs4: deal with autofs4_write/autofs4_write races) at
> fs/autofs4/waitq.c:79, but I don't really know the code so if someone
> could have a look that would be great.
> 

Yes, see http://lkml.indiana.edu/hypermail/linux/kernel/1201.1/02312.html

milton
