Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2KUTaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:30:25 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:56328 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2KUTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:30:24 -0500
Date: Wed, 21 Nov 2012 19:34:30 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PULL] Yama update (3.8)
Message-ID: <20121121193430.GA9928@mail.hallyn.com>
References: <20121120195503.GA28563@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120195503.GA28563@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Hi James,
> 
> Please pull these Yama changes for 3.8. Thanks!
> 
> -Kees,
> 
> The following changes since commit b5666502700855a1eb1a15482005b22478b9460e:
> 
>   drivers/char/tpm: remove tasklet and cleanup (2012-11-01 15:23:14 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/yama-3.8
> 
> for you to fetch changes up to 235e752789eb65a81477bb82845323dfcbf93012:
> 
>   Yama: remove locking from delete path (2012-11-20 10:32:08 -0800)
> 

Sorry, I never saw the new version of the second patch in my email (likely
my bad, i'm quick to delete), but looking at gitweb it looks good, thanks.

Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>

thanks,
-serge
