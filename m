Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1HWR67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:58:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51396 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab1HWR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:58:52 -0400
X-Sasl-enc: 0yVzre9htsHMRkoNIV4keJ9wPEKT08rweV3JzcGZpecI 1314122331
Date: Tue, 23 Aug 2011 10:57:52 -0700
From: Greg KH <greg@kroah.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110823175752.GA4129@kroah.com>
References: <CAMOw1v6uCMhgErrfPLQ5CSa0v_OoHhJ=M3OCL+YH9H1Zg5fEXQ@mail.gmail.com>
 <1312484238-1645-1-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312484238-1645-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:57:18PM -0300, Lucas De Marchi wrote:
> Adding support for poll() in sysctl fs allows userspace to receive
> notifications of changes in sysctl entries. This adds a infrastructure
> to allow files in sysctl fs to be pollable and implements it for
> hostname and domainname.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> ---
>  fs/proc/proc_sysctl.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sysctl.h  |   22 ++++++++++++++++++++++
>  include/linux/utsname.h |   16 ++++++++++++++++
>  kernel/sys.c            |    2 ++
>  kernel/utsname_sysctl.c |   23 +++++++++++++++++++++++
>  5 files changed, 108 insertions(+), 0 deletions(-)

Who is going to take this through their tree?

I can through the driver-core tree if no one else objects.

Any objections?

thanks,

greg k-h
