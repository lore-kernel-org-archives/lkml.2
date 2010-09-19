Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0ISVkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 17:40:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49625 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751924Ab0ISVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 17:40:48 -0400
Date: Sun, 19 Sep 2010 23:40:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Lars Lindley <lindley@coyote.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: Re: [PATCH] w35und: Add locking problems to TODO list
Message-ID: <20100919214039.GB12416@elf.ucw.cz>
References: <1284890661-14221-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284890661-14221-1-git-send-email-penberg@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The w35und uses atomics such as "ThreadCount" and "FireCount" to emulate
> locking in the TX paths, for example. Document this bug in the TODO list.
> 
> Cc: Lars Lindley <lindley@coyote.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>  drivers/staging/winbond/TODO |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
> index 43bee56..b4c592a 100644
> --- a/drivers/staging/winbond/TODO
> +++ b/drivers/staging/winbond/TODO
> @@ -6,6 +6,7 @@ TODO:
>  	- remove unused ioctls
>  	- use cfg80211 for regulatory stuff
>  	- fix 4k stack problems
> +	- fix locking problems (it's done using atomics...)

Being more verbose here would be good; list all the variables or at
least structures they are in, or something...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
