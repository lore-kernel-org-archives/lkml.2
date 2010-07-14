Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0GNXkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:40:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396Ab0GNXkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:40:22 -0400
Date: Wed, 14 Jul 2010 16:38:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
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
Message-Id: <20100714163852.b3c09930.akpm@linux-foundation.org>
In-Reply-To: <20100709185450.GA29473@kroah.com>
References: <20100709185450.GA29473@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 11:54:50 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> This is no longer needed by any userspace tools, so it's safe to
> remove.

Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
.config change sticks:

@@ -106,8 +106,7 @@
 CONFIG_LOG_BUF_SHIFT=17
 CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
 # CONFIG_CGROUPS is not set
-CONFIG_SYSFS_DEPRECATED=y
-CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set

and the box still won't boot.
