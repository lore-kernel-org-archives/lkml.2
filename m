Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0KSOpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:45:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64809 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0KSOpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jsjMkJyJJ6mwSYGEL6EobmdKvS01Ucs4oT2xdsaxcyrmvi/gL+WkwnJkKTr/LO+nqJ
         +ntmvTNFAPnTMw0MqG6hjOl8asJf/GgFAb+UXToiE+9LF8mu2L5ormLG/B2bKmS9UbIn
         3ngR1Pb4VR+DyMjxWS1jmBJceVwUzDr9oDSoY=
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
From: Namhyung Kim <namhyung@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
	 <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 23:45:28 +0900
Message-ID: <1290177928.1678.51.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2010-11-19 (금), 07:57 -0500, Theodore Tso:
> On Nov 19, 2010, at 5:13 AM, Namhyung Kim wrote:
> 
> > * break long lines (using temp variables if needed)
> > * merge short lines
> > * put open brace on the same line
> > * use C89-style comments
> > * remove a space between function name and parenthesis
> > * remove a space between '*' and pointer name
> > * add a space after ','
> > * other random whitespace fixes
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> What's the benefit of such massive cleanup patches, really?   Does it
>  really enhance readability _that_ much?
> 
> I believe in cleaning up code as I make substantive, useful change, but
>  code churn for code churn's sake has a number of downsides:
> 
> *) It breaks other people's patches that might be pending (probably not
>  as much of an issue for ext3)
> *) It makes it really easy to introduce
>  security holes in code (although it looks like --- I haven't checked
>  to make sure --- this shouldn't change the compiled code any so we can
>  at least audit this by applying the patch, and then checking to make
>  sure the .o hasn't changed.   What really makes my skin crawl is a
>  massive change like that which doesn't have zero impact on the
>  compiled object code.  If I get a patch like that, I reject it out of
>  hand for ext4.)
> 
> Bottom line is I really don't think cleanup code helps a lot.  It
>  wastes your time --- why not find some way of improving the kernel
>  that has more impact --- and it wastes the time of the responsible
>  maintainer (who has to go through the code with a fined-toothed comb
>  to make sure there's nothing bad hidden in a massive patch like this).
> 
> Best regards,
> 
> -- Ted
> 

Hi Ted,

I wrote this patch because checkpatch complains about the code when I
tried to write another. Since I saw many codes in namei.c doesn't
conform the kernel coding style so I decided to write this coding style
patch first and others on top of it. But if you think it is totally
useless, I'm fine with dropping it.

BTW, I just checked that compiled code itself has no change on x86_64,
but there was a change in .rodata section.

Thanks.

-- 
Regards,
Namhyung Kim


