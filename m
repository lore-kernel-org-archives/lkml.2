Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2KEUKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:10:04 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55387 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2KEUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:10:01 -0500
Date: Mon, 5 Nov 2012 12:09:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121105200955.GA26735@htj.dyndns.org>
References: <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102165123.GB3823@mtj.dyndns.org>
 <509407B7.3030904@redhat.com>
 <20121102175350.GB27843@mtj.dyndns.org>
 <50951A0E.9010103@redhat.com>
 <20121103145052.0da49071@pyramind.ukuu.org.uk>
 <20121105181809.GE19354@mtj.dyndns.org>
 <20121105201208.2ea500cc@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105201208.2ea500cc@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alan.

On Mon, Nov 05, 2012 at 08:12:08PM +0000, Alan Cox wrote:
> There are two sensible choices here IMHO
> 
> - The simple sysctl
> 
> - Doing the job right
> 
> A half way solution such as that you are proposing seems to me to achieve
> nothing other than guaranteeing we'll have another pile of useless crap
> to maintain forever as ABI.

I'm all for simple.  Just throw in a sysfs binary switch to allow all
SG_IO for a given block device for users w/ write access.  I'd be
completely happy with that.

Thanks.

-- 
tejun
