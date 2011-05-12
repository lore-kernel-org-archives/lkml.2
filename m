Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1ELM5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:57:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1ELM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:57:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Thu, 12 May 2011 14:54:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201105112344.44171.arnd@arndb.de> <4DCB88A4.2010901@grandegger.com>
In-Reply-To: <4DCB88A4.2010901@grandegger.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121454.47781.arnd@arndb.de>
X-Provags-ID: V02:K0:4WClrivG7ngWfI018/nbBl5tXTB3CS8+JqSNEyv76HC
 GhCjULW3gfHnsUj8P/aR8H/SWGF9XwXq4Pm7JdgTG9WWCLCUle
 77yzoFtXDU0c2SO47NOM4f60GwG6Jp5tD80fi87TZ3WgVDkLqH
 LnSF3qCSILrFuJXFbF2l1dUOpjIyzGNjHqeODkxPuIeQcBSNGS
 rgiaWSIynRov7sJaMmXrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 May 2011, Wolfgang Grandegger wrote:
> Well, that seems sophisticated resulting in a complex implementation
> (may code line) also because hardware filters are very hardware
> dependent. Usually just one global filter can be defined. I think that's
> overkill. A simple interface using:
> 
>   ip link set can0 type can filter <id>:<mask> [<id>:<mask> ...]
> 
> would just be fine.

Ok, fair enough. Still I would suggest you first come up with
a reasonable user interface (the one you posted may be just right,
I don't know), and then let someone do the implementation in the
pruss firmware that is the best match for the user interface, rather
than the other way around.

	Arnd
