Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0I0K2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:28:25 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab0I0K2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:28:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19616.29125.40521.717013@pilspetsen.it.uu.se>
Date: Mon, 27 Sep 2010 12:28:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #19072] [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
In-Reply-To: <sQALkqF1FWE.A.0zD.Zo6nMB@chimera>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
	<sQALkqF1FWE.A.0zD.Zo6nMB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D19072
> Subject	: [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2010-09-23 17:02 (4 days old)
> Message-ID	: <19611.34846.813757.309183@pilspetsen.it.uu.se>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128526136531048&w=3D2

Still present in 2.6.36-rc5.
