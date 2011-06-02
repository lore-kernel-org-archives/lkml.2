Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1FNGl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:41:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34935 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753087Ab1FNGl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:41:56 -0400
Date: Fri, 3 Jun 2011 00:19:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alberto Mardegan <mardy@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, "Javier S. Pedro" <maemo@javispedro.com>,
        linux-input@vger.kernel.org
Subject: Re: Reporting screen/laptop orientation data to userspace
Message-ID: <20110602221925.GC14328@ucw.cz>
References: <4DE1FA7F.3050308@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE1FA7F.3050308@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>   the WMI interfaces in some Lenovo Ideapad laptops provide notification
> callbacks when the laptop orientation changes, reporting 4 different
> values defining the new orientation.

Zaurus has two microswitches, indicating one of 3 configurations:

notebook, closed

notebook, open

tablet

They are exported as event/switch in the input. If possible, it would
be nice to have one interface for that, too. (And it probably should
be input,  and not fake-accelerator based; after all, there are no
accelerometers on zaurus-like systems).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
