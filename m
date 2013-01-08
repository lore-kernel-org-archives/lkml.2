Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3AHTGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:06:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3AHTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:06:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Date: Tue, 8 Jan 2013 19:06:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <201301071333.56733.arnd@arndb.de> <20130108001947.GE16982@verge.net.au>
In-Reply-To: <20130108001947.GE16982@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081906.32685.arnd@arndb.de>
X-Provags-ID: V02:K0:KBOm4/fQ3NKqw3X2SApGg78MDAqUvVcFORUXjtv5y+9
 BJwLxI6taBMfr3R1HKoTpLm1i9P7CZN5bOsb8ve5sOhDEUzE4z
 KFqJm4YInbBtx+wId6ixQYZ6GftubLgo/caZeutL6Z/N3XUz+n
 ioX7ApT4TWrNhoNkQbJ2qYrFSYjoFJ1cipM1twP9NaMkTs33kp
 3We6oP9F44kCyY5R4J+eJoylMDyaJJVIvlkrzaNKnfqmp09Mrh
 EebyOdUZHSg+YeoOY40u1ghc/12pF5yWO8H4kmda4IYDltZMIf
 zhcpsrYoyVWZTIFbFsJVLIqvewQRsdHGJFCNtwCryRIBwbhw/c
 nPk0w9vn/60UthWGXJRA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Simon Horman wrote:
> > 
> > Should we mark that patch for stable backports?
> 
> I don't believe it warrants a stable backport as
> the board appears to function well without the change.

Ok, fair enough. I was thinking of getting rid of the build warning in the older
kernel, but it's probably not worth it if there is no functional impact.

	Arnd
