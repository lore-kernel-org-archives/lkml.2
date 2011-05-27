Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1E0OXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:23:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1E0OXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:23:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v2] arch/tile: more /proc and /sys file support
Date: Fri, 27 May 2011 16:23:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105252220.23948.arnd@arndb.de> <201105261648.p4QGmNKf001636@farm-0023.internal.tilera.com>
In-Reply-To: <201105261648.p4QGmNKf001636@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271623.15735.arnd@arndb.de>
X-Provags-ID: V02:K0:8oFw4qjfIgX0ZyDgREE1wW9btVw9Olhk/m7pKNwKtcj
 pCqbW/ohrJJnw/pgdA6etXD0wcszlf3VLZRBmy16OL+XS5ajmA
 zWHPNsoZSkS+rLr9I6ePG/IiDr8udC35JRWd6oLVhi0ZeTy5qB
 r1XcenwLqVrJCZyQXe01m6oxwH3SQAphqUuT+YQLDBEDDVRxEb
 GL9W0Ce8eLh9ceeo/QgEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, Chris Metcalf wrote:
> This change introduces a few of the less controversial /proc and
> /proc/sys interfaces for tile, along with sysfs attributes for
> various things that were originally proposed as /proc/tile files.
> It also adjusts the "hardwall" proc API.

Looks good to me now, except

> Finally, after some feedback from Arnd Berghamm for the previous

typo					^^^^

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
