Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1DQSQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:16:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57297 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1DQSQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:16:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #29672] [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Date: Sun, 17 Apr 2011 20:16:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.A5F.k5uqNB@chimera> <3577387.Ms3I5Hp20k@segfault.sh0n.net>
In-Reply-To: <3577387.Ms3I5Hp20k@segfault.sh0n.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172016.49571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 17, 2011, Shawn Starr wrote:
> On Sunday, April 17, 2011 03:52:09 PM Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.37 and 2.6.38.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> It is continuing, using the external microphone the audio is too quiet no 
> matter how loud I set it with PulseAudio.
> 
> The audio onboard Lenovo W500 laptop is: Conexant CX20561 (Hermosa)  
> 
> I have not had time to do any investigations to look at the git changes made.

Thanks for the update.

Rafael
