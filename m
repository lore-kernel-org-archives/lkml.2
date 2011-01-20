Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1ATTO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:14:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65343 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ATTO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iUSwu7lmkz6UWv6xAw0Am/ErGDlsz7cA1uK/SKifkh0wcVr93r2/raKastQsbf/TgS
         niSchKfOih3drjZbuk5vSjZ9f3azqNqdvOg2Q+7904+S+VulN93qHAW9s4wyivZUJ1Ae
         72qDPm/tLf77FuYWhCwQRdVkCsCog9kyeI5ck=
Date: Thu, 20 Jan 2011 20:13:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
        "Theodore Ts'o" <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
        linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Message-ID: <20110120191341.GB4701@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
 <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
 <20110113074603.GC27381@tux1.beaverton.ibm.com>
 <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
 <20110115173211.GC27123@htj.dyndns.org>
 <AANLkTi=MiY+GMXRwfOMhEzGQC3=F89FOKAJ4y1hvyDG0@mail.gmail.com>
 <20110120185057.GA4701@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120185057.GA4701@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:50:57PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 18, 2011 at 09:12:55AM +0800, Shaohua Li wrote:
> > This makes sense. would it possible N flush data payloads delay the
> > first request?
> 
> I ended up with a different design.  Still buggy.  It triggers a weird
> oops under stress test but other than that things generally seem to
> work as expected.  Please read the comment at the top of blk-flush.c
> for more info.  I'll post properly after more testing and debugging.

The oops was caused by debugging code I put in (not posted together).
It runs fine without it, so if you have some time, please give it a
spin.

Thanks.

-- 
tejun
