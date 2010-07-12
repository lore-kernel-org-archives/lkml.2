Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0GLNni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:43:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab0GLNng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:43:36 -0400
Date: Mon, 12 Jul 2010 09:49:11 -0400
From: Josef Bacik <josef@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Josef Bacik <josef@redhat.com>,
        Giangiacomo Mariotti <gg.mariotti@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100712134911.GC15754@dhcp231-156.rdu.redhat.com>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com> <4C3ABF96.9070405@msgid.tls.msk.ru> <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com> <20100712134347.GB15754@dhcp231-156.rdu.redhat.com> <4C3B1BAC.1050907@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3B1BAC.1050907@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 05:42:04PM +0400, Michael Tokarev wrote:
> Josef Bacik wrote:
> []
> > O_DIRECT support was just introduced recently, please try on the latest kernel
> > with the normal settings (which IIRC uses O_DIRECT), that should make things
> > suck alot less.  Thanks,
> 
> Um.  Do you mean it were introduced in BTRFS or general? :)
> 
> Because, wel, O_DIRECT is here and supported since some 2.2 times... ;)

Btrfs obviously.

Josef
