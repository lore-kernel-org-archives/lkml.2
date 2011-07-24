Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1GXIgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:36:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55337 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751984Ab1GXIgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:36:32 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+hxSdQkISh2a6eec9T5m7W6/m0AFUK94OlolMngi
	sPotmGcjOpAPGu
From: Toralf =?iso-8859-2?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Sun, 24 Jul 2011 10:36:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201107232127.34255.toralf.foerster@gmx.de> <201107232227.37429.toralf.foerster@gmx.de> <201107232335.35204.rjw@sisk.pl>
In-Reply-To: <201107232335.35204.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107241036.20538.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote at 23:35:35
> On Saturday, July 23, 2011, Toralf Förster wrote:
> > Rafael J. Wysocki wrote at 21:48:44
> > 
> > > I wonder what happens if the machine is undocked?
> > 
> > No.
> > BTW with "no_console_suspend" I got the attached kernel crash.
> 
> What happens if the iwlagn driver is unloaded before suspend?
Yep - then it works fine.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
