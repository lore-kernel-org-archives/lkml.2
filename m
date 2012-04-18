Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2DRIhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:37:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DRIhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:37:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 0/8] Second patchset for LPC32xx device tree conversion
Date: Wed, 18 Apr 2012 08:06:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, thierry.reding@avionic-design.de,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <20120417205001.GH6498@mwanda>
In-Reply-To: <20120417205001.GH6498@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204180806.16848.arnd@arndb.de>
X-Provags-ID: V02:K0:MYLeK+3Tv9W7CP0lC0WFKouPvBQZ1m+R4vsq4TnVZck
 dxI8wTANMFQhiGEkl+HX+xbj4UUyoAg6MLlOBWmDJJ2fb8+O5r
 wXIA4n6UumafuuTMsdbkUg2ZA+kQobfD6Wc/CKnurt385s7wq8
 0CV6Qq8u8gj+Xbh9tTodhRwxHZNhOxXXgN+D9UsrpoflvAzr3I
 kkPLesY7NWOUh1c6QG5GsmG1ejI7RceKdtwudbqJuzQlNfvzxe
 qE+sgDmcadBKQ1XnTZql1Jdx/Q7NcgdkVc0OgFjEGvnM8kLqmT
 CSCqP7sM4GRGvdVvxuSUnK1nuwn3BLS8yZnpT6LIosgl+L82ii
 7j5+MPjN/0QdzCUX1wGk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Dan Carpenter wrote:
> On Tue, Apr 17, 2012 at 07:08:19PM +0200, Roland Stigge wrote:
> > Applies to v3.4-rc3
> > 
> 
> This probably applies fine (the previous version did a couple days
> ago), but it's always best to submit patches against linux-next.
> The 3.4 kernel is in -rc already so this is 3.5 material.

I disagree. The patches won't get applied on -next, they get applied
on an -rc release, so they should be submitted against that version
as well. I agree that it makes sense to test patches against -next
when there is reason to believe there might be conflicts, but it's
not mandatory. When you know about conflicts against other patches
that are already in -next, I suggest listing them in the cover 
letter (the patch 0/x) and suggest a resolution.

	Arnd

