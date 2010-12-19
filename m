Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab0LSTAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 14:00:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37663 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932385Ab0LSTAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 14:00:22 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+1qLYf8xW1yJXv/c+SNhnAaLF4WcHhAZobauYumy
	Cuzsprsgjkvvm+
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
Date: Sun, 19 Dec 2010 20:00:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Linville <linville@tuxdriver.com>
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de> <201012152214.29452.PeterHuewe@gmx.de> <AANLkTikPVqaZE8KBOCKWuwkqRpn3mHKQn+V3bUU5cW7=@mail.gmail.com>
In-Reply-To: <AANLkTikPVqaZE8KBOCKWuwkqRpn3mHKQn+V3bUU5cW7=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012192000.14969.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 17 Dezember 2010, 12:30:15 schrieb Sedat Dilek:
> On Wed, Dec 15, 2010 at 10:14 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> > Am Mittwoch 15 Dezember 2010, 21:51:04 schrieb Randy Dunlap:
> >> > Hi, another patch was posted before:
> >> > 
> >> > http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/970/ma
> >> > tch =acpi_wmi
> >> >Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Yeah, you're right - but as Sedat's patch is perfect (and fixes both) -
> > so for Sedats's patch:
> > Acked-by: Peter Huewe <peterhuewe@gmx.de>
> > 
> > Thanks,
> > Peter
> 
> [ CC John Linville ]
> 
> It's a bit disappointing to see my fix is still not in
> platform-drivers-x86/linux-next [1] (even it's only fixing "warnings",
> 9 days past).
> linux-next tree is for me a very high dynamic SCM tree, I am doing
> mostly daily builds, at weekend I am testing/pulling other trees
> before they go into Monday's linux-next.
> As far as I have fun with "my process"... I will continue.



Added Stephen Rothwell on CC, maybe he can apply it directly to linux-next ;)

Peter
