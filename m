Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0GLNiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab0GLNiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:38:15 -0400
Date: Mon, 12 Jul 2010 09:43:47 -0400
From: Josef Bacik <josef@redhat.com>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com> <4C3ABF96.9070405@msgid.tls.msk.ru> <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 03:34:44PM +0200, Giangiacomo Mariotti wrote:
> On Mon, Jul 12, 2010 at 9:09 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> >
> > This looks quite similar to a problem with ext4 and O_SYNC which I
> > reported earlier but no one cared to answer (or read?) - there:
> > http://permalink.gmane.org/gmane.linux.file-systems/42758
> > (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
> > try a few other options, esp. cache=none and re-writing some guest
> > files to verify.
> >
> > /mjt
> >
> Either way, changing to cache=none I suspect wouldn't tell me much,
> because if it's as slow as before, it's still unusable and if instead
> it's even slower, well it'd be even more unusable, so I wouldn't be
> able to tell the difference. What I can say for certain is that with
> the exact same virtual hd file, same options, same system, but on an
> ext3 fs there's no problem at all, on a Btrfs is not just slower, it
> takes ages.
>

O_DIRECT support was just introduced recently, please try on the latest kernel
with the normal settings (which IIRC uses O_DIRECT), that should make things
suck alot less.  Thanks,

Josef 
