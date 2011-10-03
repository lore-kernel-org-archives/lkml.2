Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1JCJy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:54:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1JCJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:54:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
Date: Mon, 03 Oct 2011 11:54:41 +0200
Message-ID: <5055144.Y0IUdMEWXQ@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E898010.80208@ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <3656685.pM1zNST8gQ@wuerfel> <4E898010.80208@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:y+UHHAagusT+iJQbz0XnW82dBgODRdQs6Pak29To0Qv
 a2g6RWLP+NbNHmbtS97Bwi1fE4kjXzyWyE/E+KVUDebBljLAUG
 JxMvB+4iBCcLPkt1BrxpFnx06SECMrMevGItwFhoW1tL/NfQRc
 sE1mO4A7IXms0oQZa/FbtIDq6ISfS2wU3ChlDIlu7fdmJ6L9PT
 0McYw5x8TEqyGhTV3fshEUGbP1SrW+Qf9Dc7JfeO3UqCunxc4U
 qhP3u4QTQ7DazgkqTLNPzLI8JosY+4CCL7ewW8H5Rr+fMbifNz
 TdeosDHa5xeqW7wjck2vzoWG0WPsGzgb6p15gQ3Nmlj2d5vD4g
 9S8StATba1OJ0loYZLSo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 11:27:44 Cousson, Benoit wrote:
> >
> > In the long run, I'd hope we can just get rid of these for subarchitectures
> > that support device tree probing and make the device tree based machine
> > description unconditional.
> 
> This is really our goal, we will have soon the board-generic.c for that, 
> someone will just have to migrate these ~30 board files to device tree 
> DTS files 

For the purpose of build-time validation using randconfig, there is no
problem in keeping some board files forever, as long as the generic board
file is always built-in.

	Arnd
