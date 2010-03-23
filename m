Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0CWItz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:49:55 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39986 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752764Ab0CWItx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:49:53 -0400
Date: Tue, 23 Mar 2010 09:49:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: Dan Carpenter <error27@gmail.com>, gregkh@suse.de, greg@kroah.com,
       penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: phy_calibration.c Coding style fixes
	1/2.
Message-ID: <20100323084952.GB27015@atrey.karlin.mff.cuni.cz>
References: <1269267447-6245-1-git-send-email-lindley@coyote.org> <20100322142924.GA23411@bicker> <4BA783AA.8060108@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA783AA.8060108@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [PATCH] staging: winbond: phy_calibration.c de-indent #ifdefs etc.
> 
> Removed indentation of the #ifdefs etc.
> This applies after patch in:
> Message-Id: <1269267447-6245-2-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/phy_calibration.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
