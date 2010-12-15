Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0LOVOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:14:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751979Ab0LOVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:14:32 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19qAWJjjYtqKbnJjYM1GDJJzDAWsT9Mh8eoPDcWb8
	F87EREv69JLM+K
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
Date: Wed, 15 Dec 2010 22:14:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@googlemail.com>
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de> <AANLkTin+vOvpK4geMKdcx4wiOSc_EdPNwXJAcFTaCcnf@mail.gmail.com> <4D092A38.7020407@oracle.com>
In-Reply-To: <4D092A38.7020407@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012152214.29452.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 15 Dezember 2010, 21:51:04 schrieb Randy Dunlap:
> > Hi, another patch was posted before:
> > 
> > http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/970/match
> > =acpi_wmi
Thanks for the information.

> > Your patch seems to miss TC1100_WMI section.
> 
> Yes, it would be better to do both (all) of them the same way.
Yeah, you're right - but as Sedat's patch is perfect (and fixes both) - so for 
Sedats's patch:
Acked-by: Peter Huewe <peterhuewe@gmx.de>

Thanks,
Peter
