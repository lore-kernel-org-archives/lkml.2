Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1EYUsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab1EYUsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:48:02 -0400
Date: Wed, 25 May 2011 16:47:52 -0400
From: David Teigland <teigland@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 26/34] dlm: Drop __TIME__ usage
Message-ID: <20110525204752.GA2114@redhat.com>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-27-git-send-email-mmarek@suse.cz>
 <4DDD6AD4.6040801@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDD6AD4.6040801@suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:47:16PM +0200, Michal Marek wrote:
> Dne 5.4.2011 16:59, Michal Marek napsal(a):
> > The kernel already prints its build timestamp during boot, no need to
> > repeat it in random drivers and produce different object files each
> > time.
> > 
> > Cc: Christine Caulfield <ccaulfie@redhat.com>
> > Cc: David Teigland <teigland@redhat.com>
> > Cc: cluster-devel@redhat.com
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> >  fs/dlm/main.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Hi,
> 
> I don't see this patch in today's linux-next. Any objection against me
> applying it to the kbuild-2.6.git repository?

No, please do.
Thanks,
Dave

