Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2IBHaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:30:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2IBHaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:30:15 -0400
Date: Sun, 2 Sep 2012 09:30:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oskar Schirmer <oskar@scara.com>
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, John Anthony Kazos Jr <jakj@j-a-k-j.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: fix broken utf8 encoding
In-Reply-To: <1345542849-13621-1-git-send-email-oskar@scara.com>
Message-ID: <alpine.LNX.2.00.1209011024140.28562@deuxcents.site>
References: <1345542849-13621-1-git-send-email-oskar@scara.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Oskar Schirmer wrote:

> conversion to utf8 left some extra control character here,
> remove it.
>
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> Documentation/power/swsusp.txt |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
> index 92341b8..0b4b63e 100644
> --- a/Documentation/power/swsusp.txt
> +++ b/Documentation/power/swsusp.txt
> @@ -53,7 +53,7 @@ before suspend (it is limited to 500 MB by default).
>
> Article about goals and implementation of Software Suspend for Linux
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> -Author: G????bor Kuti
> +Author: G??bor Kuti
> Last revised: 2003-10-20 by Pavel Machek
>
> Idea and goals to achieve

Well, your MTA didn't make it any better by not encoding it properly :)

I have fixed it manually and applied.

-- 
Jiri Kosina
SUSE Labs

