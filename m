Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0LSNl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:41:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38844 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab0LSNl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:41:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #23902] [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Date: Sun, 19 Dec 2010 14:40:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera> <6Ue85L6pKCJ.A.YfE.iefDNB@chimera> <19726.1077.824539.753038@pilspetsen.it.uu.se>
In-Reply-To: <19726.1077.824539.753038@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191440.59315.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 19, 2010, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23902
> > Subject		: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2010-11-27 15:16 (23 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/305e6835e05513406fa12820e40e4a8ecb63743c
> > Message-ID	: <<19697.8378.717761.236202@pilspetsen.it.uu.se>>
> > References	: http://marc.info/?l=linux-kernel&m=129087098911837&w=2
> 
> The regression is still present in 2.6.37-rc6.

Thanks for the update.

Rafael
