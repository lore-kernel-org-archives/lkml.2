Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab0HEJ65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:58:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52631 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab0HEJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:58:51 -0400
Subject: Re: [PATCH] Change struct flchip_shared spinlock locking into mutex
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, Vasiliy Kulikov <segooon@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1280992766-13745-1-git-send-email-stefani@seibold.net>
References: <1280992766-13745-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:37:47 +0300
Message-ID: <1281001067.15689.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Aug 2010 09:39:06.0220 (UTC) FILETIME=[0C046AC0:01CB3482]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 09:19 +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch prevent to schedule while atomic by changing the
> flchip_shared spinlock into a mutex. This should be save since no atomic
> path will use this lock.
> 
> This patch is based on linux kernel 2.6.35. Please apply.
> 
> It was suggested by Arnd Bergmann and Vasiliy Kulikov.

Pushed to my l2-mtd-2.6.git / master.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

