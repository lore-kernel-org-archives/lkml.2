Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2KEUPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:15:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37663 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2KEUPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:15:16 -0500
Date: Mon, 5 Nov 2012 12:15:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121105201512.GB26735@htj.dyndns.org>
References: <5093DD5E.6030808@redhat.com>
 <20121102165123.GB3823@mtj.dyndns.org>
 <509407B7.3030904@redhat.com>
 <20121102175350.GB27843@mtj.dyndns.org>
 <50951A0E.9010103@redhat.com>
 <20121103145052.0da49071@pyramind.ukuu.org.uk>
 <20121105181809.GE19354@mtj.dyndns.org>
 <20121105201208.2ea500cc@pyramind.ukuu.org.uk>
 <20121105200955.GA26735@htj.dyndns.org>
 <20121105201754.7d82deff@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105201754.7d82deff@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 08:17:54PM +0000, Alan Cox wrote:
> IMHO that's the best option for now - if it fixes the specific case of
> concern right now. It's a trivial interface, it's trivial security (need
> to check CAP_SYS_RAWIO to flip) and it means that the job can be done
> properly when there is consensus without a whole extra legacy API stuck
> behind.

Oh yeah, fully agreed.  We could just set the sysfs file only
writeable by root (basically just setting perm to 0644).  Would the
CAP_SYS_RAWIO distinction matter?

Thanks.

-- 
tejun
