Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0ITNwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:52:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56374 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0ITNww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:52:52 -0400
Date: Mon, 20 Sep 2010 15:52:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Stefan Roese <stefan.roese@gmail.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-2.6-stable.git abandoned?
Message-ID: <20100920135257.GB5349@kryptos.osrc.amd.com>
References: <158DE6B2-4FA4-4213-A63F-76BC94D539D9@googlemail.com>
 <20100920071800.49ef5e19@bike.lwn.net>
 <201009201535.09341.stefan.roese@gmail.com>
 <20100920073806.32e174f4@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920073806.32e174f4@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, Sep 20, 2010 at 07:38:06AM -0600

> On Mon, 20 Sep 2010 15:35:08 +0200
> Stefan Roese <stefan.roese@gmail.com> wrote:
> 
> > Hmmm, looking at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary
> > 
> > The last change went 3 weeks ago into this git repository.
> 
> Try:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
> 
> if you want 2.6.34 updates.

Actually, I use the first repo above for stable updates too because it
conveniently contains all 2.6.3x releases. Isn't that one the official
combined repo for stable updates? Can we have some clarification from
the -stable team on which repo we should take?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
