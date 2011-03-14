Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1CNPdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:33:40 -0400
Received: from smtp.nokia.com ([147.243.1.48]:49335 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1CNPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:33:38 -0400
From: Felipe Contreras <felipe.contreras@nokia.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
To: greg@kroah.com
Cc: omar.ramirez@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ohad@wizery.com, fernando.lugo@ti.com,
        tuomas@kulve.fi
In-Reply-To: <20110313010633.GD20396@kroah.com>
References: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com> <20110312173626.GC24981@kroah.com> <AANLkTinp0e4EiEH=XV9gCSJzoh-VAY-6qqs91x0s80ro@mail.gmail.com> <20110313010633.GD20396@kroah.com>
User-Agent: notmuch 0.5-80-ge98c04f
Message-ID: <1300116128-notmuch-felipe.contreras@nokia.com>
Date: Mon, 14 Mar 2011 17:33:09 +0200
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

greg@kroah.com wrote:
> On Sun, Mar 13, 2011 at 01:42:35AM +0200, Felipe Contreras wrote:
> > On Sat, Mar 12, 2011 at 7:36 PM, Greg KH <greg@kroah.com> wrote:
> > > How about I send it to Linus for .39 and then add it to the .38-stable
> > > tree when it comes out?
> > 
> > That was the plan for .38/.37-stable. I'd say that's fine, but it
> > would be even better to avoid people getting bit by this on plain .38.
> 
> What is one more week, when you all waited months to get this to me?  In
> other words, why should I suddenly now rush when no one else did?

The reason is because it didn't seem like it was happening often, but
in Tuomas' case, it does so much it's basically unusable. So _now_ we
know this could have possibly been affecting many people we didn't know
about.

You have to remember that this driver only started to work on .37, so
people might have tried it, seen it crashing and said "oh well, it's on
'staging' for a reason", having no point of reference that would be a
valid conclusion, while in fact this is a regression from pre-staging
(the issue wasn't there).

Anyway, I don't think .38.1 is going to be released in one week, but I
guess if people are having issues and not reporting them, they can wait
more.

Cheers.

-- 
Felipe Contreras
