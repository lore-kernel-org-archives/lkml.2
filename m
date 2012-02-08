Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2BHSsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:48:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45772 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab2BHSsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:48:51 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Josh Boyer <jwboyer@redhat.com>
Subject: Re: 3.3-rc2 snd_pcm lockdep backtrace
Date: Wed, 8 Feb 2012 19:48:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc2; KDE/4.6.5; x86_64; ; )
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20120206145621.GA4771@zod.bos.redhat.com> <201202081854.08668.maciej.rutecki@gmail.com> <20120208181014.GA6188@zod.bos.redhat.com>
In-Reply-To: <20120208181014.GA6188@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202081948.46548.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 8 lutego 2012 o 19:10:15 Josh Boyer wrote:
> On Wed, Feb 08, 2012 at 06:54:08PM +0100, Maciej Rutecki wrote:
> > On poniedziałek, 6 lutego 2012 o 15:56:22 Josh Boyer wrote:
> > 
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=42746
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> Er... why exactly?
> 
> I mean, great I don't really mind at all that a bugzilla.kernel.org bug
> was opened, but
> 
> 1) there's already a bug opened in the RH bugzilla for this
> 2) I've already emailed the upstream developers and list about it
> 3) ALSA actually has it's own bug tool
> 
> so unless the ALSA devs are going to do something with that particular
> bug I don't see a huge amount of value.
> 
> As an aside, I'm basically an intermediary here.  The original reporter
> in the RHT bug should probably add their email to CC.
> 
> josh

We use bugzilla.kernel.org to tracking regressions in one place (as database). 
I search LKML for it. It does not matter that you use another case for resolve 
bug. But it will be useful, when you send information about status of this bug 
(solved, invalid etc.).

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
