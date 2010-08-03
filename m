Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0HCIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:25:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0HCIZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:25:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: stefani@seibold.net
Subject: Re: [PATCH] Change struct flchip_shared spinlock locking into mutex
Date: Tue, 3 Aug 2010 10:25:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org
References: <1280778048-6208-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1280778048-6208-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008031025.52409.arnd@arndb.de>
X-Provags-ID: V02:K0:KMnFIomcCNIjvEpCu+0vbAEJj0N8KA5Ocv1cfrs0vXf
 1SO0Bg6A3VM9t9AKffs0CVVQZOIFVfLzDQI5dZprT++gJZzURH
 D+HskEsOENdVIL5nseesHAjgTkti1M95WsMi1oj+YvfJgqiRRQ
 xKhp3OsKxfinjfIXoH1GlRVfHdRPjuEfsWeOouBFSQMyCvq2Oc
 4xP9bhzczhWAUthv+olKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch prevent to schedule while atomic by changing the
> flchip_shared spinlock into a mutex. This should be save since no atomic
> path will use this lock.

I don't know this code well, but the patch looks correct and seems
to be needed.

Acked-by: Arnd Bergmann <arnd@arndb.de>
