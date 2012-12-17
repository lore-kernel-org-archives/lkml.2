Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2LQK1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:27:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2LQK1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:27:17 -0500
Date: Mon, 17 Dec 2012 11:27:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
Message-ID: <20121217102714.GB31947@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michal Marek <mmarek@suse.cz>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
 <50CEF080.8010208@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CEF080.8010208@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:14:24AM +0100, Michal Marek wrote:
> On 14.12.2012 23:19, Cesar Eduardo Barros wrote:
> > This small script checks the file patterns in the MAINTAINERS file.
> > 
> > For every file pattern, it checks if the pattern matches any file or
> > directory in the kernel tree, printing the patterns which do not have a
> > match.
> 
> Can't this be added as a warning to scripts/get_maintainer.pl instead?

Yep, it definitely makes more sense than having a standalone script.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
