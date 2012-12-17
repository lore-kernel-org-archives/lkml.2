Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2LQRAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:00:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44518 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab2LQRAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:00:14 -0500
Date: Mon, 17 Dec 2012 18:00:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
Message-ID: <20121217170011.GC31866@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Michal Marek <mmarek@suse.cz>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
 <50CEF080.8010208@suse.cz>
 <20121217102714.GB31947@liondog.tnic>
 <1355758544.13361.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355758544.13361.14.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 07:35:44AM -0800, Joe Perches wrote:
> Perhaps Cesar can use his script as a starting point to find those
> pattern invalidating commits or maybe add the capability (or a
> --strict check) to checkpatch.

Or that, I don't have a strict preference.

So, yeah, I can see how checkpatch saying: "you've just renamed a
file and thusly invalidated a pattern in MAINTAINERS. Pls, consider
correcting the pattern" could make sense. And I would even add it to
default functionality since the MAINTAINERS patterns are something we
want to always have up-to-date, IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
