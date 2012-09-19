Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2ISSjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:39:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2ISSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:38:58 -0400
Date: Wed, 19 Sep 2012 11:38:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andre Przywara <andre.przywara@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the workqueues tree with the pm
 tree
Message-ID: <20120919183853.GM8474@google.com>
References: <20120919135625.875ebc4d68279b26f2375150@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919135625.875ebc4d68279b26f2375150@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 01:56:25PM +1000, Stephen Rothwell wrote:
> Hi Tejun,
> 
> Today's linux-next merge of the workqueues tree got a conflict in
> drivers/cpufreq/powernow-k8.c between commit e1f0b8e9b04a ("cpufreq:
> Remove support for hardware P-state chips from powernow-k8") from the pm
> tree and commit 5d7efe7bf90f ("cpufreq/powernow-k8: workqueue user
> shouldn't migrate the kworker to another CPU") from the workqueues tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

Yeap, looks correct to me.  FYI, the change is likely to be pulled
into 3.6-rc6 soonish.

Thanks.

-- 
tejun
