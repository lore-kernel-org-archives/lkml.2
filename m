Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2DQPlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:41:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50565 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2DQPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:41:41 -0400
Message-ID: <4F8D8F2D.7030704@landley.net>
Date: Tue, 17 Apr 2012 10:41:33 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, trivial@kernel.org,
        kjsisson@bellsouth.net, Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ben Dooks <ben@simtec.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Andy Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josua Dietze <digidietze@draisberghof.de>,
        Andiry Xu <andiry.xu@amd.com>, Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] [Trivial] Documentation: Add newline at end-of-file to
 files lacking one
References: <alpine.LNX.2.00.1204162329190.21898@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204162329190.21898@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 04:35 PM, Jesper Juhl wrote:
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

Acked-by: Rob Landley <rob@landley.net>

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
