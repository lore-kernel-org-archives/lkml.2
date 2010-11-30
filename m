Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0K3WgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:36:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab0K3WgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:36:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tim Sander <tim01@iss.tu-darmstadt.de>
Subject: Re: Its winter in the northern hemisphere (aka various 2.6.37 regeressions)
Date: Tue, 30 Nov 2010 23:35:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
References: <201011302258.13212.tim01@iss.tu-darmstadt.de>
In-Reply-To: <201011302258.13212.tim01@iss.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011302335.37008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 30, 2010, Tim Sander wrote:
> Hi
> 
> I am currently running 2.6.37-rc2-00056-g2811036, which shows lot of snow... 
> and yes i don't mean the snow outside of my window i mean the goddam snow on 
> my LCD Screen which is connected via DVI-D with my onboard video controller
> RS880 [Radeon HD 4290]. And yes 2.6.36 works without any snow at all (It 
> wasn't that cold outside either when i compiled it, that might be a reason ;-) 
> 
> The snow is btw. some mostly white pixel noise best only visible on a black 
> screen.
> 
> And while am it: the commit d33ef52d9db8a36900dd53f2e32db9a521ace259 breaks my 
> kde login on debian sid. Finding this error is the result of quite some 
> bisecting runs.

A revert of this commit is scheduled for inclusion into the next DRI push,
AFAICS.

Thanks,
Rafael
