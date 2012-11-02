Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2KBUVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:21:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2KBUVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:21:44 -0400
Date: Fri, 2 Nov 2012 13:21:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102202131.GE9169@htj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102153530.483453c7@pyramind.ukuu.org.uk>
 <20121102164828.GA3823@mtj.dyndns.org>
 <20121102172145.184abfe3@pyramind.ukuu.org.uk>
 <20121102173022.GA27843@mtj.dyndns.org>
 <20121102201824.41b2516d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102201824.41b2516d@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Nov 02, 2012 at 08:18:24PM +0000, Alan Cox wrote:
> a - there are lots of cases you want to allow only a subset of commands.

Care to spell them out.  At least the cases Paolo listed should be
served by what's described.

> b - if you are using a BPF filter which is the obvious way to do it then
> the flexibility comes for free without any extra complexity as the kernel
> provides a generic implementation, and even a JIT for complex cases.

Yeah, sure, but it's all about what tool to use where and maybe it's
my ignorance about the problem space but it's difficult for me to
believe that we need full-blown BPF filter here when this is the only
activity we've got in a decade.

Thanks.

-- 
tejun
