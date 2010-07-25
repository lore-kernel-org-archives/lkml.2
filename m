Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0GYWfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:35:11 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60854 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0GYWfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:35:10 -0400
Date: Mon, 26 Jul 2010 00:35:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
Message-ID: <20100725223508.GA9885@merkur.ravnborg.org>
References: <4C4C9E40.7070209@infracom.it> <201007260018.14300.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007260018.14300.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 12:18:14AM +0200, Rafael J. Wysocki wrote:
> On Sunday, July 25, 2010, Roberto Oppedisano wrote:
> > 
> > My HP6730B (x86_64 kernel, uptodate lubuntu Lucid installed) fails to suspend
> > on recent git kernels, the screen goes black (backlight on) and stays there forever.
> > 
> > Here's what I found from a bisect.
> > 

> Does it work if you revert that commit?

Roberto wrote:

> > Alas reverting that single commit on current linux/master does not
> > solve the issue so it could be that I did something wrong... anyway
> > here the log of the bisect:

So I guess not...

	Sam
