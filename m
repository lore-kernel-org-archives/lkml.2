Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2BMHox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:44:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2BMHow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:44:52 -0500
Message-ID: <1329119055.2647.35.camel@cr0>
Subject: Re: [PATCH 25/60] target: remove the second argument of
 k[un]map_atomic()
From: Cong Wang <amwang@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kiran Patil <kiran.patil@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Mon, 13 Feb 2012 15:44:15 +0800
In-Reply-To: <1328912323.9333.92.camel@haakon2.linux-iscsi.org>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	 <1328852421-19678-26-git-send-email-amwang@redhat.com>
	 <1328912323.9333.92.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 14:18 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2012-02-10 at 13:39 +0800, Cong Wang wrote:
> > Signed-off-by: Cong Wang <amwang@redhat.com>
> > ---
> >  drivers/target/target_core_transport.c |    4 ++--
> >  drivers/target/tcm_fc/tfc_io.c         |   10 ++++------
> >  2 files changed, 6 insertions(+), 8 deletions(-)
> > 
> 
> Hi Cong,
> 
> This looks fine to me, I assume you'll push this upstream..?
> 
> Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Hi,

I resent these to let Andrew take them. :)

Thanks!

