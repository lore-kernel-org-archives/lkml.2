Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0IOSxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:53:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0IOSxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 6/7] sound: autoconvert trivial BKL users to private mutex
Date: Wed, 15 Sep 2010 20:53:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1284494022-7346-1-git-send-email-arnd@arndb.de> <1284494022-7346-7-git-send-email-arnd@arndb.de> <s5haankqb44.wl%tiwai@suse.de>
In-Reply-To: <s5haankqb44.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009152053.15252.arnd@arndb.de>
X-Provags-ID: V02:K0:/m0Pv5hDtlXvIczUJICapll6T96rn33N57Bsk34plWu
 PFCsaITMCzmABZga0qzKKrym2rE/QGn45ftSlrPY+ItFex6kDb
 4oOTki00CkFd+dfz3iyB3gAcvN9PGfTIA0nKoexCjd7sPAse2A
 3I3rDSg+Ec58RRdMcfs1TFeWC2TDEW95aarBDp15ZHPG+MxZ9k
 ZhMKhHxBVezxwB7pBNOXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010 23:16:43 Takashi Iwai wrote:
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Takashi Iwai <tiwai@suse.de>
> 
> Through a quick look over the patch and the actual driver codes,
> I found no obvious problems, so I applied it now to sound git tree.

Ok, dropped from my tree.

	Arnd
