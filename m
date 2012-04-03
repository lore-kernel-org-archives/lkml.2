Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2DCPfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:35:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2DCPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:35:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: Linux 3.4-rc1
Date: Tue, 3 Apr 2012 15:35:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Kyungmin Park <kmpark@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, hdoyu@nvidia.com, konrad.wilk@oracle.com
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com> <201204030907.29306.arnd@arndb.de> <CAH3drwaGz0m_hnZqj41yAFXVLc++ZFBYR4G-ydUa6=NrkS78kQ@mail.gmail.com>
In-Reply-To: <CAH3drwaGz0m_hnZqj41yAFXVLc++ZFBYR4G-ydUa6=NrkS78kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204031535.15867.arnd@arndb.de>
X-Provags-ID: V02:K0:7sOLlquDt+a91VzKf/jzEhQIOTaiVRQM2uh4S/faKdO
 Dak+tXjViVxnf6tFlNruSWYFOMDrXiyzr3VkNxo172bwJl9aXc
 Lls/kvQn9URaUvIxBFiRRdbHHEIR8jrVRIuMgGLYG1Z34jGa5T
 jjzLg5xdhh4DTssoLprTHJPrRf520Ytpv+ANDJbx+4mA95xD+v
 rTk4HQXeSeMO5fX4ItJhZtUlbhdWkJVo7CICtmg9WIbC5htjqo
 2F/lc8uBKAkM5j108fO+oqejiw3MEtWfJoejNiVS0GG3+I0X1e
 7uCIekUscBDwi5uJWA7sfy9m0JPlW6m8j8emhOwmCydTgDCw0f
 etVZy8UtNFsfRlQnejpM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2012, Jerome Glisse wrote:
> Out of curiosity where is the IOMMU abstraction work being discussed ?
> Worked on ? I would like similar things on x86 platform and i spend
> sometimes thinking on it in the past. Would like to make sure this
> could also fit our need.

I think the more recent versions of that are just ARM based, not
sure about the reasons. I found an archived version here:

http://www.digipedia.pl/usenet/thread/18820/9752/

There is not much about it that is ARM specific and I'm sure it
can be lifted back into common code if there is interest.

	Arnd
