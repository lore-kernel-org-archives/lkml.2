Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2EDMXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:23:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2EDMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:22:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Shi <alex.shi@intel.com>
Subject: Re: glommer@redhat.com undelivered email address disturbers
Date: Fri, 4 May 2012 11:19:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
References: <4FA3735F.80107@intel.com>
In-Reply-To: <4FA3735F.80107@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041119.54678.arnd@arndb.de>
X-Provags-ID: V02:K0:SlJ936vhLyKkQOdWkqn5LqvPbHH8/ohSYZPSra8WSO9
 7ucXOtYMlH/xJXei0+IaIBHU0tcPy9TjkGCNivlv9McDRGvcXq
 /c1u2+3Nhk0P0rBVnahmoRnzE7xbvY4fni9KmzDJr/LXACQzJY
 poJU+QR+R2Bd/bBkFcQYw+m5OxM/Hhw6nbhuIsgU0809c+LR/a
 7DBD0xkp0ET8zCu27sE1dkTP2As0T8nDlhpvB7LHAfTtA448cp
 LffxxdBoOajmBihMlwfhbCJKu7UQcxbvXrjRrz2sTly4AndR4W
 6xb6pSD03pAChN3dOCbrnvmiXxI7tYm48z1Enia46+kGrRXFjs
 Jpz5HAatMhbnbYsViFEc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Alex Shi wrote:
> This email can not be touched, glommer@redhat.com.
> but scripts/get_maintainer.pl still give me this.
> 
> If it is possible to remove it from 2 files in
> Documentation/virtual/kvm/, or change the get_maintainer.pl to avoid it?

The output is taken from the git history, which cannot be changed. I don't
think we want to add a database of people's new email addresses in there.

	Arnd
