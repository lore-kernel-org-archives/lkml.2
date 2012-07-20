Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2GTVLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:11:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2GTVLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:11:32 -0400
Date: Fri, 20 Jul 2012 23:11:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Rob Landley <rob@landley.net>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [PATCH][Trivial][resend] Documentation: Add newline at end-of-file
 to files lacking one 
In-Reply-To: <alpine.LNX.2.00.1207202232240.23164@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207202310390.21929@pobox.suse.cz>
References: <alpine.LNX.2.00.1207202232240.23164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012, Jesper Juhl wrote:

> This patch simply adds a newline character at end-of-file to those
> files in Documentation/ that currently lack one.
> 
> This is done for a few different reasons:
> 
> A) It's rather annoying when you do "cat some_file.txt" that your
>    prompt/cursor ends up at the end of the last line of output rather
>    than on a new line.
> 
> B) Some tools that process files line-by-line may get confused by the
>    lack of a newline on the last line.
> 
> C) The "\ No newline at end of file" line in diffs annoys me for some
>    reason.
> 
> So, let's just add the missing newline once and for all.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Queued for 3.6, thanks Jesper.

-- 
Jiri Kosina
SUSE Labs
