Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab2ILE02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:26:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2ILE0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:26:25 -0400
Date: Wed, 12 Sep 2012 12:36:47 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Hugh Dickins <hughd@google.com>, Arvydas Sidorenko <asido4@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>, linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Storage related regression in linux-next 20120824
Message-ID: <20120912043647.GA3084@gmail.com>
Mail-Followup-To: Jeff Garzik <jgarzik@pobox.com>,
	Hugh Dickins <hughd@google.com>,
	Arvydas Sidorenko <asido4@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>, linux-kernel@vger.kernel.org,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com>
 <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com>
 <503BA2DB.9080704@gmail.com>
 <503BB4BB.4080307@gmail.com>
 <alpine.LSU.2.00.1209090012390.2416@eggly.anvils>
 <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com>
 <504CFBE3.401@pobox.com>
 <CANsGZ6aPB6ZjTmUJ=xeLY68iV5V9ghGGAQrp9KvJcyC0d-ARUg@mail.gmail.com>
 <504D0127.5080807@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504D0127.5080807@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 04:50:47PM -0400, Jeff Garzik wrote:
> On 09/09/2012 04:36 PM, Hugh Dickins wrote:
> >On Sun, Sep 9, 2012 at 1:28 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> >>I'll send Linus a patch to disable.
> >
> >Thanks, but no, the change in question hasn't reached Linus yet, it's
> >just a linux-next or mmotm thing - isn't it?
> 
> Yep, libata-dev#upstream.  Sorry, got my own branches confused for a
> second there.

Sorry for delay reply.  In our product system, we tested a lot of
different brands of SATA disks, and it is OK after fua is enabled on
default.  Certainly we can't test all disks. :-(

So I think we quite have to revert my patch now, and try to fix the
current problem.

Regards,
Zheng
