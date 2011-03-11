Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1CKLz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:55:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1CKLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:55:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Fri, 11 Mar 2011 12:55:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Sage Weil" <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Jonathan Nieder" <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
In-Reply-To: <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111255.44979.arnd@arndb.de>
X-Provags-ID: V02:K0:bDU4pHUc31r9VA3feu0q/ZBR+OcgfklBnSGHLNQOHay
 vHwmMOvENRKmdJTvAyqry+dihbtia4jkvr5gOR0mu11Wns56ee
 CZ955LuymESuKSsKaDQesbcu/W6xsLeQewsWpFtKYYOdMyWBcC
 Gp/Neq0XAXjfQT+Y23cs1Qw7wScynCJABPl2VwvA/tcZm+HRvy
 b/MFbM1YtPOxnsM1vlVrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Indan Zupancic wrote:
> >       http://marc.info/?l=linux-fsdevel&amp;m=127970513829285&amp;w=2
> 
> The patch there seems much more reasonable than introducing a whole
> new systemcall just for 20 lines of kernel code. New system calls are
> added too easily nowadays.

The only problem with adding new system calls is that we are stuck with
the interface until the end of time, so we must be sure not to get it
wrong. The same thing is true for any other interface such as ioctl
or extensions to existing system calls. People usually get away with
adding new ioctls more easily because it is less obvious when they
are added.

	Arnd
