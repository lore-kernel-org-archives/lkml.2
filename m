Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2ILTCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:02:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2ILTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:02:47 -0400
Date: Wed, 12 Sep 2012 12:02:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Rob Landley <rob@landley.net>
Subject: Re: [patch] cgroups: trivial fixes for
 Documentation/cgroups/cgroups.txt
Message-ID: <20120912190242.GT7677@google.com>
References: <504F1E74.10709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F1E74.10709@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 01:20:20PM +0200, Michael Kerrisk wrote:
> While reading through Documentation/cgroups/cgroups.txt, I found a
> number of minor wordos and typos. The patch below is a conservative
> handling of some of these: it provides just a number of "obviously
> correct" fixes to the English that improve the readability
> of the document somewhat. Obviously some more significant
> fixes could be made to the document, but some of those 
> may not be in the "obviously correct" category.

Applied to cgroup/for-3.7.  Thanks!

-- 
tejun
