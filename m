Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0L3Lqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:46:47 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:12688 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0L3Lqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:46:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19740.28963.209423.649799@pilspetsen.it.uu.se>
Date: Thu, 30 Dec 2010 12:46:43 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #23902] [BUG] 2.6.37-rc3 massive interactivity regression on ARM
In-Reply-To: <sV7shrPOroO.A.2AG.N_7GNB@chimera>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	<sV7shrPOroO.A.2AG.N_7GNB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23902
> Subject		: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2010-11-27 15:16 (33 days old)
> First-Bad-Commit: http://git.kernel.org/linus/305e6835e05513406fa12820e40e4a8ecb63743c
> Message-ID	: <<19697.8378.717761.236202@pilspetsen.it.uu.se>>
> References	: http://marc.info/?l=linux-kernel&m=129087098911837&w=2

Fixed in 2.6.37-rc7.
