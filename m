Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2KHPCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:02:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2KHPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:02:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH 2/2] ARM: davinci: enable SRAM ping ping buffering on DA850
Date: Thu, 8 Nov 2012 15:02:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, gururaja.hebbar@ti.com,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
References: <1349345745-10584-1-git-send-email-mporter@ti.com> <1349345745-10584-3-git-send-email-mporter@ti.com>
In-Reply-To: <1349345745-10584-3-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211081502.04980.arnd@arndb.de>
X-Provags-ID: V02:K0:X8N34vw0U61FG4aZOqN1PBtLinoVktjqglPlxEoj2Bz
 FzuzrizD4VkTz2OogX5/OufDkz8HLRS7g6AAtgTjgiyDHeNvaT
 +OP4Ods0C0CbGZHGjes0sEZ28ij9vraDZ6pPXsCThBovSFjGEH
 Um3DKCq6Z3QyjwKRkRJ1qMUunEQEk5atltm2iS4pxZD79uY8+n
 OrLk+EhXZHdTt9qzTX2WMvwEM2Ig1fofKB8KQ6pxvX7lZuixwA
 vBZ7McxY4X0LQH8X72THsZjzk4qUwLGtAMS/niatrM/hKAv151
 xmvoan8v4br48/DULvIMIIPXVHOiE9WHDw0/A/A7rxAtPL8L00
 veMe2TPfWwWp+U0vEwpU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012, Matt Porter wrote:
> Passes the DA850 shared SRAM gen_pool to the McASP driver
> and enables the ping-pong buffer DMA support.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---

It seems this is in linux-next now, but the patch it depends on
(ARM: davinci: add platform hook to fetch the SRAM pool) is not.

	Arnd
