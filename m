Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab1LMFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:16:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50385 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1LMFQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:16:23 -0500
Message-ID: <1323753537.10514.0.camel@nisroch>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 13 Dec 2011 15:18:57 +1000
In-Reply-To: <4EE564CF.8090203@gmail.com>
References: <4EE2E9BB.8060801@gmail.com>
			<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com>
		 <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>
		 <4EE42ADA.5000406@gmail.com> <1323590203.31951.2.camel@nisroch>
	 <4EE564CF.8090203@gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 19:19 -0700, Berck E. Nash wrote:
> On 12/11/2011 12:56 AM, Ben Skeggs wrote:
> > If you can manage to reproduce it, hopefully in some reliable way, it'll
> > be a huge help.
> 
> Well, I can confirm it's a real regression.  It's happened again, and
> I've never seen anything like it before.  Unfortunately, I can't offer
> any reasonable steps to reproduce it for testing.  It's only happened
> when watching video with mplayer, but it seems to happen at a rate of
> about once per hour while watching video.  Enough to be seriously
> annoying, but not enough to be seriously useful when testing.
> Definitely enough to keep me from upgrading.
> 
> I'm open to whatever else might be helpful if you have any ideas.  Log
> of the last occurrence attached.
Are you able to bisect this back to a commit?  I've attempted on a few
different cards to cause this and I'm not seeing it.

It might take a while to bisect given that it's hard for you to
reproduce, but, it'd be *very* helpful.

Ben.

> 
> Berck Nash


