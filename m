Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2FKW0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:26:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39845 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FKW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:26:40 -0400
Date: Mon, 11 Jun 2012 15:26:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam Hansen <sam@meebo-inc.com>
Cc: devel@driverdev.osuosl.org, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH V2 3/3] staging: zram: conventions, line splitting
Message-ID: <20120611222636.GA22569@kroah.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
 <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
 <20120611160438.GA24331@kroah.com>
 <CALJ0CeiibyAAJQC4kVxMLTEx=6dzZdzivpfHi4b3W-dst3Ha6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALJ0CeiibyAAJQC4kVxMLTEx=6dzZdzivpfHi4b3W-dst3Ha6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 03:08:13PM -0700, Sam Hansen wrote:
> >  drivers/staging/zram/zram_drv.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > This patch no longer applies to the tree :(
> 
> Hi Greg,
> I wrote the patch against Linus' tree
> <http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git>.
> Is it more appropriate to write code against your staging tree
> <http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git>?
> 
> Have I been writing code against the wrong tree?  If so,  I'm a huge
> tool and sorry for the confusion :p

Problem is, other zram changes just went into my tree, so they probably
conflicted with your changes as well.

So yes, it's best to work against my staging-next branch for coding
style cleanups, or the linux-next tree, either should be fine.

thanks,

greg k-h
