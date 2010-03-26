Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0CZDK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:10:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57012 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZDK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:10:27 -0400
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
References: <20100324031829.2136.66489.stgit@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 20:10:15 -0700
In-Reply-To: <20100324031829.2136.66489.stgit@notabene.brown> (NeilBrown's message of "Wed\, 24 Mar 2010 14\:20\:08 +1100")
Message-ID: <m1sk7npylk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: neilb@suse.de, linux-kernel@vger.kernel.org, gregkh@suse.de, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> This series tidies up the refcount of sysfs_dirents in sysfs,
> using kref where appropriate and a new karef for s_active.
> This achieves significant code simplification, especially the first
> patch.
>
> This is in part inspired by http://lwn.net/Articles/336224/ :-)

Neil I would appreciate if you would cc' Tejun and myself on
these kind of patches as we wrote the code and the best canidates
to review it.

Thanks,
Eric
