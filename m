Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2LSNh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:37:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2LSNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:37:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Subject: Re: [GIT PULL] f2fs: request for tree inclusion
Date: Wed, 19 Dec 2012 13:37:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        "f2fs-dev" <linux-f2fs-devel@lists.sourceforge.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
References: <1355212688.7291.151.camel@kjgkr> <1355613547.2376.7.camel@kjgkr> <CAJL_dMtPRkq8TeB9dpmxCWMO-zjO-nKnwQvZ8CknNcM6mR8Zag@mail.gmail.com>
In-Reply-To: <CAJL_dMtPRkq8TeB9dpmxCWMO-zjO-nKnwQvZ8CknNcM6mR8Zag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201212191337.09541.arnd@arndb.de>
X-Provags-ID: V02:K0:cTCZT/NzsH+6ehkvUoqj3kTVLwdhRfvJrd4VpAzbuYN
 g17Zm+FfNZ+qmurJsyxKNGvbFTsT97qYqs5GqnWhahU65+Qqn2
 JRfbrh7vOGjp3hy50KZLyqzN8QlnIdoH7x4XpxNEpi15lPsWhv
 PepHCph9HBySs6aZc0Z1gJfQE9xGifKj/sPNI9p1N6N6KaNnPi
 EaJyhs81G9zal00pcqV81/YHaJYOOmrdD8/MIBeybbFiPHaHb/
 gyP9CuaHqMNAieemyYDHKTMMWEiFaNJPhkJvPkIYBFZtBjt3mQ
 8BhCbCy5qpnHlKXvjaR5nmm5eRIaNgulLNqMqKUJHtSXHULFBT
 J6xsT+86ZrUaAH5Fuv3o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012, Anca Emanuel wrote:
> 
> Hi Linus,
> 
> An early prototype of this:
> https://wiki.linaro.org/WorkingGroups/Kernel/Specs/flash-file-system-prototype
> 
> Are you still testing it ?

The prototype was an earlier and independent work done as an internship
in Linaro. It resulted in very valuable insights, some of which ended
up being integrated into f2fs, but we decided not to follow up on that
work since f2fs is far superior overall and has a dedicated team working
on it. There are a few features from the prototype that we might want
to add in f2fs, but those can be implemented as compatible changes
later.

	Arnd
