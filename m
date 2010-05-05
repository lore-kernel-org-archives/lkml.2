Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0EEUH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:07:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab0EEUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:07:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [Bug #15590] 2.6.34-rc1: regression: ^Z no longer stops sound
Date: Wed, 5 May 2010 22:08:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jarkko Nikula <jhnikula@gmail.com>, Takashi Iwai <tiwai@suse.de>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera> <8VO9AsMlpMD.A.H_B.XKJ4LB@chimera> <20100505081342.GF30801@buzzloop.caiaq.de>
In-Reply-To: <20100505081342.GF30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052208.17010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Daniel Mack wrote:
> On Tue, May 04, 2010 at 11:21:14PM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15590
> > Subject		: 2.6.34-rc1: regression: ^Z no longer stops sound
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2010-03-14 7:58 (52 days old)
> > Message-ID	: <20100314075831.GA13457@elf.ucw.cz>
> > References	: http://marc.info/?l=linux-kernel&m=126855353122623&w=2
> 
> According to alsa-devel, this is fixed by 0f17014b.

Thanks, closing.

Rafael
