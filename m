Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1BCNf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:35:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:42032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab1BCNf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:35:26 -0500
Date: Thu, 3 Feb 2011 14:35:24 +0100
From: Matthias Hopf <mat@mshopf.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #26932] [SNB mobile] Oops in DRM intel driver, esp.
 during S3/S4 stress test
Message-ID: <20110203133524.GB5123@suse.de>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
 <-tcJxClTQPH.A.AWE.Q7eSNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <-tcJxClTQPH.A.AWE.Q7eSNB@chimera>
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 03, 11 01:05:28 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).

The original issue of this bug is not a regression. Though during trying
to reproduce with the latest kernel I stumbled over two regressions (one
regarding frame buffer compression, already fixed in intel-drm-fixes,
one regarding S3 trampoline code and NX, fix available, bug 27472).

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26932
> Subject		: [SNB mobile] Oops in DRM intel driver, esp. during S3/S4 stress test
> Submitter	: Matthias Hopf <mat@mshopf.de>
> Date		: 2011-01-17 11:45 (17 days old)

Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de
