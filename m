Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1HEJMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:12:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1HEJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:11:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org
Subject: Re: [PATCH 0/8] overlay filesystem: request for inclusion
References: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
	<20110804231134.GO2203@ZenIV.linux.org.uk>
Date: Fri, 05 Aug 2011 11:11:42 +0200
In-Reply-To: <20110804231134.GO2203@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 5 Aug 2011 00:11:34 +0100")
Message-ID: <87liv8nrxt.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Simple: please, *please* hold back until we have atomic_open mess
> sorted out.  I'm fucking sick and tired of playing whack-a-mole in
> that area - for nearly three years by now; we fortunately are very
> close to getting this shit done right - the main remaining obstacle is
> ->d_revalidate() abuse by NFS and I seriously hope to get it over and
> done with in a week or so.

Sure, that's a totally reasonable thing to ask.

What I ask in return is that you please make your development a bit more
open.

You know it's really annoying when you say something like the above and
then you say it year after year and apparently nothing changes.  If you
could share your work at least we could see what's going on and maybe
even help sort out some of the pieces.  If you are doing it in private,
it looks to be whack-a-mole for years to come.

And I've been asking for this many times, and never got a response.  At
least you could explain why it always has to be a large piece of work
(of excellent quality, btw) suddenly dropped into mainline without
anybody ever seeing any of it previously.

Thanks,
Miklos
