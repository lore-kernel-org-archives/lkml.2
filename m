Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1I0NIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab1I0NIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:08:48 -0400
Date: Tue, 27 Sep 2011 09:08:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
Message-ID: <20110927130843.GA24673@redhat.com>
References: <1316142577.29510.130.camel@sli10-conroe>
 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
 <1316155239.29510.148.camel@sli10-conroe>
 <CADX3swqAq=zpFtWogbuRnARjjZK753esKihs3tzLQkbiRE2y0Q@mail.gmail.com>
 <1316603780.2001.12.camel@shli-laptop>
 <20110923132441.GA10289@redhat.com>
 <CADX3swpctg-yENZE0178x5SS3PTKB3qZE+=vEfNJwqydxLJ95g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADX3swpctg-yENZE0178x5SS3PTKB3qZE+=vEfNJwqydxLJ95g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 09:34:16AM +0200, Corrado Zoccolo wrote:

[..]
> >
> > Anyway, what's wrong with the idea I suggested in other mail of expiring
> > a sync-noidle queue afer few reuqest dispatches so that it does not
> > starve other sync-noidle queues.
> I don't know the current state of the code. Are the noidle queues
> sorted in some tree, by sector number?
> If that is the case, then even an expired queue could still be in
> front of the tree.

I am not aware of any queue sorting based on sector number on sync-noidle
tree. So we should just be able to do round robin.

Thanks
Vivek
