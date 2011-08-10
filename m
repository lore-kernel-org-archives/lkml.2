Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1HJNyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1HJNx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:53:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 2/2] blktrace: add FLUSH/FUA support
References: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
	<1312957924-2316-2-git-send-email-namhyung@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Aug 2011 09:53:50 -0400
In-Reply-To: <1312957924-2316-2-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Wed, 10 Aug 2011 15:32:04 +0900")
Message-ID: <x497h6ls781.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
> FUA follows WRITE, use the same 'F' flag for both cases and
> distinguish them by their (relative) position. The end results
> look like (other flags might be shown also):
>
>  - WRITE:            W
>  - WRITE_FLUSH:      FW
>  - WRITE_FUA:        WF
>  - WRITE_FLUSH_FUA:  FWF

I was hoping we'd go with Jens' suggestion of relacing W with F for flush,
and have FUA appear after that.  However, I can live with this, so if
others like it, it's fine by me.

Thanks for doing this, Namhyung!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
