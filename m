Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1EZIma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1EZIm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:42:28 -0400
Subject: Re: [PATCH 27/34] gfs2: Drop __TIME__ usage
From: Steven Whitehouse <swhiteho@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
In-Reply-To: <4DDD6B1F.1060303@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <1302015561-21047-28-git-send-email-mmarek@suse.cz>
	 <4DDD6B1F.1060303@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 26 May 2011 09:43:54 +0100
Message-ID: <1306399434.2893.2.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-05-25 at 22:48 +0200, Michal Marek wrote:
> Dne 5.4.2011 16:59, Michal Marek napsal(a):
> > The kernel already prints its build timestamp during boot, no need to
> > repeat it in random drivers and produce different object files each
> > time.
> > 
> > Cc: Steven Whitehouse <swhiteho@redhat.com>
> > Cc: cluster-devel@redhat.com
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> >  fs/gfs2/main.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Hi,
> 
> I don't see this patch in today's linux-next. Any objection against me
> applying it to the kbuild-2.6.git repository?
> 
> Thanks,
> Michal
> 
No, I think that should be ok. It was added as a method to spot when
someone had compiled their own module against a distro kernel, but tbh
this isn't a problem in practice, so I don't think it will be a problem,

Steve.


