Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2FEUxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:53:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56494 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2FEUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:53:29 -0400
Date: Tue, 5 Jun 2012 22:55:05 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 3/3] led: add oneshot trigger
Message-ID: <20120605205504.GA1350@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
 <1338074364-1829-3-git-send-email-fabio.baltieri@gmail.com>
 <1338134989.2968.18.camel@lorien2>
 <20120531210117.GA2400@gmail.com>
 <CAK5ve-LS2qJKTihbdbhEnW3cOQzqB6phtJm0=Djt6znqwjf4CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-LS2qJKTihbdbhEnW3cOQzqB6phtJm0=Djt6znqwjf4CA@mail.gmail.com>
X-Operating-System: Linux balto-eee 3.5.0-rc1-balto-eee-00008-g4a25fe7-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Tue, Jun 05, 2012 at 03:37:39PM +0800, Bryan Wu wrote:
> >
> > Ok, anyway as your patch has been mainlined and this (totally?) overlaps
> > with it I think it's ok to just use this to test the API of first patch
> > of this set.
> >
> 
> Shuah's leds patches are all in mainline now. But I think this trigger
> is still useful for an good example to use the new API.
> And it is easy for user to use the oneshot trigger from here.
> 
> I've already merged 2 patches from you, so if you like, please follow
> Shuah's advice to cleanup this trigger and resend.

Ok, I found another small bug so I'm sending a v2 patchest on a separate
thread for clearness.

Fabio

> 
> 
> -- 
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.186-168-78255 Mobile
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
