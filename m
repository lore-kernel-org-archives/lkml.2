Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1GHARJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab1GHARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:17:08 -0400
Date: Thu, 7 Jul 2011 17:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: `make headers_check' bustage
Message-Id: <20110707171627.4f15035e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is just me, or is headers_check busted in current -linus?

z:/usr/src/25> make mrproper; make allmodconfig; make headers_check
...
/usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
/usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
/usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
/usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

