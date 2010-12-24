Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0LXU6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:58:52 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:49098 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0LXU6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:58:51 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
	<m3aajvz5na.fsf@intrepid.localdomain>
	<4D14BB36.1030304@msgid.tls.msk.ru>
Date: Fri, 24 Dec 2010 21:58:38 +0100
In-Reply-To: <4D14BB36.1030304@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Fri, 24 Dec 2010 18:24:38 +0300")
Message-ID: <m34oa23n29.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> No, this is about TLER.  The "desktop" drives like this will try
> re-read data in case of error, and if that does not work the
> raid code will most likely declare the drive's dead and kick
> it off the array.  Drives which are supposed to work in RAID
> config has configurable timeouts/retries, so that the RAID
> code will be able to take care of read errors.

Assuming the controller won't kick the drive off anyway, and it most
probably will.

In this case, no drives fail, so it doesn't matter.
Guess we should then see the partition table(s).
-- 
Krzysztof Halasa
