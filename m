Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0IMT0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:26:34 -0400
Received: from bar.sig21.net ([80.81.252.164]:46675 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0IMT0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:26:31 -0400
Date: Mon, 13 Sep 2010 21:26:26 +0200
From: Johannes Stezenbach <js@sig21.net>
To: dave b <db.pub.mail@gmail.com>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: block cache replacement strategy?
Message-ID: <20100913192626.GA15092@sig21.net>
References: <20100907133429.GB3430@sig21.net>
 <20100909120044.GA27765@sig21.net>
 <20100910120235.455962c4@schatten.dmk.lab>
 <20100910160247.GA637@sig21.net>
 <20100913152138.GA16334@sig21.net>
 <AANLkTikoUAgRV18axesaiYnpBWe2V-xhALgh7dtF7p3Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikoUAgRV18axesaiYnpBWe2V-xhALgh7dtF7p3Y@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.015,BAYES_05=-1.11 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 05:09:31AM +1000, dave b wrote:
> On 14 September 2010 01:21, Johannes Stezenbach <js@sig21.net> wrote:
> > On Fri, Sep 10, 2010 at 06:02:48PM +0200, Johannes Stezenbach wrote:
> >>
> >> Linear read heuristic might be a good guess, but it would
> >> be nice to hear a comment from a vm/fs expert which
> >> confirms this works as intended.
> >
> > Anyway I found lmdd (from lmbench) can do random reads,
> > and indeed causes the data to enter the block (page?) cache,
> > replacing the previous data.
> 
> I am no expert, but what did you think would happen if you did dd
> twice from /dev/zero?
> but... Honestly what do you think will be cached?

It's not from /dev/zero, it is from file to /dev/null.

It all started with me wanting to compare disk read bandwidth
vs. read bandwidth of my root partition via dm-crypt + LVM,
and then wondering why dd from raw disk seemed to be
cached while dd from crypted root partition didn't.


Johannes
