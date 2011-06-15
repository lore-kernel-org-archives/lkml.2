Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1FOGIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:08:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44029 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751344Ab1FOGI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:08:29 -0400
Date: Wed, 15 Jun 2011 06:08:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: Powersave doesn't work for snd_hda_intel with 3.0.0-rc2
Message-ID: <20110615060818.GA21679@localhost.ucw.cz>
References: <20110609085616.GA4207@tiehlicka.suse.cz> <20110609090607.GB4207@tiehlicka.suse.cz> <s5hei33xsxn.wl%tiwai@suse.de> <20110609092826.GC4207@tiehlicka.suse.cz> <s5haadrxrsm.wl%tiwai@suse.de> <20110609111401.GA3994@tiehlicka.suse.cz> <s5htybyw52q.wl%tiwai@suse.de> <20110610075640.GA4832@tiehlicka.suse.cz> <s5hhb7yw16i.wl%tiwai@suse.de> <20110610083956.GE4832@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610083956.GE4832@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-06-10 10:39:56, Michal Hocko wrote:
> [changed subject]
> 
> As a summary:
> I am loosing sound after powe_save timeout expires if there is no device
> activity. The only way how to get sound back is to unload the module and
> load it again.

Hmm, today my x60 with 3.0-rc was strangely quiet. Coincidence?
     	      	       pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
