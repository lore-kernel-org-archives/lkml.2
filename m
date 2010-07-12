Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0GLUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0GLUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:24:35 -0400
Date: Mon, 12 Jul 2010 16:24:25 -0400
From: Josef Bacik <josef@redhat.com>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100712202424.GC2881@localhost.localdomain>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com> <4C3ABF96.9070405@msgid.tls.msk.ru> <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com> <20100712134347.GB15754@dhcp231-156.rdu.redhat.com> <AANLkTimWPLqEf4LjHx39zO7yzkJ_c157OjOm3UnBRgJ2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimWPLqEf4LjHx39zO7yzkJ_c157OjOm3UnBRgJ2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:23:14PM +0200, Giangiacomo Mariotti wrote:
> On Mon, Jul 12, 2010 at 3:43 PM, Josef Bacik <josef@redhat.com> wrote:
> >
> > O_DIRECT support was just introduced recently, please try on the latest kernel
> > with the normal settings (which IIRC uses O_DIRECT), that should make things
> > suck alot less.  Thanks,
> >
> > Josef
> >
> With latest kernel do you mean the current Linus' git tree? Because if
> instead you're talking about the current stable kernel, that's the one
> I used on my test.
> 

Yes Linus' git tree.  Thanks,

Josef
