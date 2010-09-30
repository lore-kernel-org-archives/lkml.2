Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0I3NNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:13:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761Ab0I3NNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:13:39 -0400
Date: Thu, 30 Sep 2010 08:58:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Zaurus driver being loaded when it shouldn't.
Message-ID: <20100930065836.GA1510@ucw.cz>
References: <20100928170704.GA523@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928170704.GA523@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have a Dell Adamo laptop which has a wwan device which
> is triggering zaurus.ko to get loaded, probably due to this
> wildcard match..
> 
>  alias:          usb:v*p*d*dc*dsc*dp*ic02isc0Aip00*
> 
> Full lsusb -v is at http://davej.fedorapeople.org/usb

Unfortunately, I don't use usb device mode on zaurus, but hopefully
someone on zaurus list does, and can provide lsusb...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
