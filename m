Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2EVCG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:06:29 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:53827 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2EVCG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:06:28 -0400
Date: Tue, 22 May 2012 02:08:57 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org,
        Amos Kong <akong@redhat.com>
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
Message-ID: <20120522020857.GA10499@mail.hallyn.com>
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
 <20120518081912.16779.21065.stgit@t>
 <20120521140324.GA5091@sergelap>
 <4FBADF1A.6040303@huawei.com>
 <20120522015426.GA10344@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522015426.GA10344@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At line 135, there is

if (walk->type == DEV_ALL)
	goto remove;

I wonder if that was meant to be 'if (wh->type == DEV_ALL)'.  That
seems to fit better with what I would have meant to have happen.
But it's already handled by line 342.  So I think deleting lines
135-136 might be best.  What do you think?

Thanks again, Amos and Li.

-serge
