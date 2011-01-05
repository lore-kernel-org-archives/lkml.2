Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1AEQA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:00:59 -0500
Received: from kroah.org ([198.145.64.141]:34890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1AEQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:00:46 -0500
Date: Wed, 5 Jan 2011 07:57:34 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] kref: add kref_test_and_get
Message-ID: <20110105155734.GC2072@kroah.com>
References: <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <1294157114.3579.102.camel@edumazet-laptop>
 <4D2487F9.8030704@redhat.com>
 <AANLkTinnVv5wE0U=RrSKR40-u88VC8_XMctx=X0O3Tg7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinnVv5wE0U=RrSKR40-u88VC8_XMctx=X0O3Tg7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 05:43:22PM +0200, Alexey Dobriyan wrote:
> On Wed, Jan 5, 2011 at 5:02 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
> > Add kref_test_and_get() function, which atomically add a reference only if
> > refcount is not zero. This prevent to add a reference to an object that is
> > already being removed.
> 
> Is kref supposed to be used only for "toy" structures where you aren't
> expected to do get possibly dead object?

Of course not, have you read the kref documentation?

{sigh}

Why do we even write these things if no one reads them...

greg k-h
