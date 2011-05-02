Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1EBVNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:13:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab1EBVNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:13:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gottfried Haider <gottfried.haider@gmail.com>
Subject: Re: [Bug #33482] [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3 (works in 2.6.38.3)
Date: Mon, 2 May 2011 23:13:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.caE.nVGvNB@chimera> <BANLkTimiSXHSxsjPH03Yey555U+F4m1uOA@mail.gmail.com>
In-Reply-To: <BANLkTimiSXHSxsjPH03Yey555U+F4m1uOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022313.46554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 02, 2011, Gottfried Haider wrote:
> Hello Rafael,
> 
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=33482
> > Subject         : [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3 (works in 2.6.38.3)
> > Submitter       : Gottfried Haider <gottfried.haider@gmail.com>
> > Date            : 2011-04-16 16:38 (15 days old)
> > Message-ID      : <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=130297197128328&w=2
> 
> This can be removed from the regression list as it turned out to be
> only a mis-config-uration (oldconfig listed BT_L2CAP as a new config
> option, defaulting to false, when it had been build as a module
> before).

Thanks, closing.

Rafael
