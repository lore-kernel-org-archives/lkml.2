Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685Ab0EVBPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:15:52 -0400
Received: from c60.cesmail.net ([216.154.195.49]:42347 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756Ab0EVBPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:15:51 -0400
Subject: Re: [PATCH] compat-wireless: add linux-next-pending, crap patch
 dirs and nagometer
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
References: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Fri, 21 May 2010 21:15:36 -0400
Message-Id: <1274490936.3439.14.camel@ct>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 20:44 -0400, Luis R. Rodriguez wrote:
> Sometimes you have no other option but to carry around patches.
> This can happen for a variety of reasons. Ultimately testing of code
> cannot happen on the kernel maintainer's clock but on your own.
> 
> This expands the idea of the linux-next-cherry-pick patch directory
> on compat-wireless to also allow for patches to be merged which are
> posted to some mailing list but pending merge due to some reasons
> (merge window is a good example). It also adds a crap patch directory
> for those really nasty situations you can run into where you have
> no other option but to give someone a release with some delta even
> if the patch is not yet posted anywhere.

Please replace "crap" with some more descriptive name, like
"unpublished".  It's better to be friendly to users and express
frustration in a different way.

> +	printf "${RED}%10s${NORMAL} - Crap changes not yet posted\n" $2
> +	printf "${RED}%10s${NORMAL} - Crap additions not yet merged\n" $3
> +	printf "${RED}%10s${NORMAL} - Crap deletions not yet posted\n" $4

You want "not yet posted" in all cases.

"Crap deletions" may be offensive for Linux contributors whose code is
being deleted.  Besides, if patches are not posted, somebody still spent
time on making them.  Let's not discourage those who care.

-- 
Regards,
Pavel Roskin
