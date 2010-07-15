Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0GOEPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 00:15:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0GOEPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 00:15:54 -0400
Date: Wed, 14 Jul 2010 20:52:30 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org,
        Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Message-ID: <20100715035230.GA2186@suse.de>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714163852.b3c09930.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 04:38:52PM -0700, Andrew Morton wrote:
> On Fri, 9 Jul 2010 11:54:50 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > This is no longer needed by any userspace tools, so it's safe to
> > remove.
> 
> Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
> back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
> .config change sticks:
> 
> @@ -106,8 +106,7 @@
>  CONFIG_LOG_BUF_SHIFT=17
>  CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>  # CONFIG_CGROUPS is not set
> -CONFIG_SYSFS_DEPRECATED=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> +# CONFIG_SYSFS_DEPRECATED_V2 is not set
>  CONFIG_RELAY=y
>  CONFIG_NAMESPACES=y
>  # CONFIG_UTS_NS is not set
> 
> and the box still won't boot.

Ick, that sucks.

What kernel was FC6 based on originally?

Kay, I thought that Fedora had fixed the "can't find root" issue for
this type of sysfs configuation a long time ago.  Or was that something
else for PPC that I am thinking of?

thanks,

greg k-h
