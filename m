Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1BPSGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1BPSGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:06:37 -0500
Date: Wed, 16 Feb 2011 13:06:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
Message-ID: <20110216180628.GF14653@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539821.1090703@cn.fujitsu.com>
 <20110210205722.GB2600@redhat.com>
 <4D55EEBB.8060304@cn.fujitsu.com>
 <20110214180428.GF13097@redhat.com>
 <4D59E728.3030209@cn.fujitsu.com>
 <20110215142752.GC27296@redhat.com>
 <4D5B2C07.9050909@cn.fujitsu.com>
 <AANLkTi=Lrb+CLo_dn9L+RhWUf7SAaTepFrdpje+PgqMX@mail.gmail.com>
 <AANLkTinUcSxJZ24NeUwQ_6W4=+atRWX-7G9K5iymuOsz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinUcSxJZ24NeUwQ_6W4=+atRWX-7G9K5iymuOsz@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:28:07AM -0800, Divyesh Shah wrote:
> On Wed, Feb 16, 2011 at 9:22 AM, Divyesh Shah <dpshah@google.com> wrote:
> > On Tue, Feb 15, 2011 at 5:44 PM, Gui Jianfeng
> > <guijianfeng@cn.fujitsu.com> wrote:
> >> Hmm, it seems memcg aggregating stats in parent group.
> >> But do we really need to do that in kernel? I think it's easier to do it in
> >> userland, and it makes kernel much simpler.
> >>
> >
> > I would prefer having stats aggregated up the hierarchy. One trick we
> > used at Google earlier was to do lazy updates for most stats. So we
> 
> Note that this was on ancient version of the blkio controller :). As
> Vivek mentioned,
> it may be ok to add the hierarchical accounting later.

One improvement we can probably do is make accounting per cpu and make
it lockless.

Thanks
Vivek
