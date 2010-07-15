Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab0GONro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:47:44 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:54234 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933243Ab0GONrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:47:43 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 09:47:43 EDT
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 09:29:01 -0400
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <m1zkxtinlw.fsf@fess.ebiederm.org>
In-Reply-To: <m1zkxtinlw.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007150929.03916.konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > and the box still won't boot.
>
> The reason FC6 doesn't boot is there is a userspace tool
> I believe in the initrd that cares about symlinks when it should
> not.

It is not just nash. Also multipathd would fail (as it expects 
the /sys/scsi_host/..<something> in certain directories), and 'lsscsi'. There 
might be other tools that depend on libsysfs to be affected by this as well.

Oh, and I think 'udev' might have some trouble too - but not 100% certain 
about that.
