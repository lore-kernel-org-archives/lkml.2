Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1G0KVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:21:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1G0KU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:20:58 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: better oopsing when frozen
Date: Wed, 27 Jul 2011 12:23:43 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc7-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201107251043.19932.oneukum@suse.de> <20110726154502.14c7b51b.akpm@linux-foundation.org> <201107271121.21348.rjw@sisk.pl>
In-Reply-To: <201107271121.21348.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107271223.43874.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Juli 2011, 11:21:21 schrieb Rafael J. Wysocki:
> > mm...  The patch as proposed is very simple, direct, explicit.  I
> > suspect that trying to embed this operation within some other one would
> > end up producing a less clear result.  Sometimes we do exceptional and
> > weird things, and leaving the code exceptional and weird-looking is
> > better than hiding it in some framework, if you follow what I mean.
> 
> My point is that instead of using the oom_killer_disabled variable in
> page_alloc.c, we could use a oom_killer_disabled() function returning
> the value of the new tasks_are_frozen variable.  Then,
> oom_killer_disable/enable() won't be necessary any more.

Well, if we do this, it'll be a separate change. Not that I disagree. 

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
