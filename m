Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1EFRcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:32:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1EFRct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:32:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Subject: Re: [Bug #33092] [regression] 2.6.39-rc1 - Beagleboard usbnet broken
Date: Fri, 6 May 2011 19:32:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>, Jamie Iles <jamie@jamieiles.com>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.rKF.XWGvNB@chimera> <4DC3EC8B.6060109@mimc.co.uk>
In-Reply-To: <4DC3EC8B.6060109@mimc.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061932.55991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 06, 2011, Mark Jackson wrote:
> On 30/04/11 20:46, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.38.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> 
> I have just tried the latest linus git and it is still broken.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33092
> > Subject		: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
> > Submitter	: Mark Jackson <mpfj-list@mimc.co.uk>
> > Date		: 2011-04-04 9:22 (27 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/087809fce28f50098d9c3ef1a6865c722f23afd2
> > Message-ID	: <4D998DC9.3040109@mimc.co.uk>
> > References	: http://marc.info/?l=linux-kernel&m=130191386508831&w=2

Thanks for the update.

Rafael
