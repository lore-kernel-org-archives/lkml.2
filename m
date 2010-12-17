Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0LQBFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:05:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab0LQBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:05:14 -0500
Subject: Re: [alsa-devel] CONFIG_SND_HDA_INTEL regression on 2.6.37-rc3 -
 no audio
From: Adam Williamson <awilliam@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5h8w0ang0e.wl%tiwai@suse.de>
References: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
	 <s5h8w0ang0e.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 17 Dec 2010 01:04:24 +0000
Message-ID: <1292547864.2025.53.camel@vaioz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 07:50 +0100, Takashi Iwai wrote:
> At Tue, 30 Nov 2010 13:31:46 -0800,
> Luis R. Rodriguez wrote:
> > 
> > I just booted 2.6.37-rc3 and noticed my sound with
> > CONFIG_SND_HDA_INTEL stopped working, I get no audio at all. Is this a
> > known regression? I can bisect if not.
> 
> I haven't heard of such a regression, so far.  Which kernel did work?
> 2.6.37-rc2 worked?  After rc2, there aren't so many commits for
> HD-audio, so if it's a regression, it's likely in another deeper
> part, I guess.

I reported a 2.6.36 to 2.6.37 regression in HDA_INTEL for my Vaio Z to
the bugtracker:

https://bugtrack.alsa-project.org/alsa-bug/view.php?id=5216

it's perfectly reproducible - I have a 2.6.36 and a 2.6.37 kernel both
installed on here, I have to boot the 2.6.36 one for sound to work and
the 2.6.37 one for bluetooth to work. =)
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Fedora Talk: adamwill AT fedoraproject DOT org
http://www.happyassassin.net

