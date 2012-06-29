Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2F2OLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:11:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2F2OLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:11:09 -0400
Date: Fri, 29 Jun 2012 09:11:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] backlight: add support for disabling backlights via sysfs
Message-ID: <20120629141100.GB23192@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
 <20120628191043.GA9777@srcf.ucam.org>
 <20120628193017.GA29456@thinkpad-t410>
 <20120628193652.GB10945@srcf.ucam.org>
 <CAHR064jEbtT9-+hNSq6Kr+uYCQX2fjcQb+kmkX2V46heCLO8vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064jEbtT9-+hNSq6Kr+uYCQX2fjcQb+kmkX2V46heCLO8vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 02:24:38PM +0200, Corentin Chary wrote:
> On Thu, Jun 28, 2012 at 9:36 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Thu, Jun 28, 2012 at 02:30:17PM -0500, Seth Forshee wrote:
> >
> >> I actually don't think Corentin's solution is a bad one. It does suffer
> >> from a couple of shortcomings though. First, it only works for broken
> >> ACPI backlights, and some platforms have other backlight interfaces that
> >> are broken (e.g. the i915 backlight on the MacBook Pro 8,2). Second,
> >> marking backlights as broken in the kernel necessitates ever-expanding
> >> dmi blacklists in some of the platform drivers, unless we can get
> >> vendors to stop providing broken backlight interfaces.
> >
> > Userspace should already be prioritising platform interfaces over raw
> > interfaces, so if gmux works on the Mac then there's no problem.
> 
> Hehe, sometime the platform interface doesn't work and the raw does.
> That's the case on various samsung-laptop since we have absolutely no
> documentation about SABI and no known way to probe if the
> implementation is working or not. But anyway, for samsung-laptop it's
> disabled by default in favor of acpi_video (which is also broken most
> of the time on samsung laptops).

The situation is similar with Toshibas. On some the raw interface is
still the only reliable way to change the backlight. I just got my hands
on one of these models though, so I'm hoping to make some progress on
that front in the near future.

