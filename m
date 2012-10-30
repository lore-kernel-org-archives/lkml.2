Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2J3P1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2J3P1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:27:13 -0400
Date: Tue, 30 Oct 2012 17:29:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Waychison <mikew@google.com>
Cc: Frank Swiderski <fes@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
Message-ID: <20121030152925.GA7023@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <20120910090521.GB18544@redhat.com>
 <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
 <20120910195931.GD20721@redhat.com>
 <CAGTjWtCiqjkR_Ze=0-ebO08+eziz6c8TXLb+O1iiArRQeSE6zw@mail.gmail.com>
 <20120910211018.GB21484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910211018.GB21484@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 12:10:18AM +0300, Michael S. Tsirkin wrote:
> > On the plus side, having an exit taken here on each page turns out to
> > be relatively cheap, as the vmexit from the page fault should be
> > faster to process as it is fully handled within the host kernel.
> > 
> > Perhaps some combination of both methods is required? I'm not sure :\
> 
> Perhaps some benchmarking is in order :)
> Can you try telling host, potentially MADV_WILL_NEED
> in that case like qemu does, then run your proprietary test
> and see if things work well enough?

Ping. Had a chance to try that?

-- 
MST
