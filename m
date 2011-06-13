Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1FMHP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 03:15:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38916 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1FMHPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 03:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Tyj3PUXohJWDwUe/RlDA+BJKb8vp+zSnq5oFHubtIK1LDBkiacB3HGl9N3zCDrFqWD
         9zjJKcVJnQcFYH6kVmSHRVe7B+di5BYAyjOymFtGEdX4oplrlxtOLVAEYGxB4dZVvsad
         9XErbBpKhnn+dV6eil5VxN95hSiagutXvLq9I=
Subject: Re: [PATCH] Documentation:fix the wrong file position in
 sched-arch.txt
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik2tgB98qyfdJJLi7_J-9_BJUp+gg@mail.gmail.com>
References: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
	 <BANLkTiknFkJ+TE5OYBuJm8gOoi1pMzbzTA@mail.gmail.com>
	 <1307941517.2703.0.camel@Tux>
	 <BANLkTik2tgB98qyfdJJLi7_J-9_BJUp+gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 13:48:27 +0800
Message-ID: <1307944107.2703.3.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2011-06-12 at 22:41 -0700, Connor Hansen wrote:
> On Sun, Jun 12, 2011 at 10:05 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> > On 日, 2011-06-12 at 21:56 -0700, Connor Hansen wrote:
> >> On Sun, Jun 12, 2011 at 9:35 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> >> > The arch i386 had changed to x86.
> >>
> >> $ grep -R "i386" Documentation/ | wc -l
> >> 155
> >>
> >> Fix them all with:
> >> grep -lZR "i386" Documentation/ | xargs -0 -l sed -i -e 's/i386/x86/g'
> >>
> >> or send ~ 100 patches
> > You see, but not all i386 can change to x86 in Documentation/
> > right?
> 
> Documentation/filesystems/fuse.txt:  limited anyway to 32 pages (which
> is 128kbyte on i386).
<snip>
> I don't see any problems,
> Connor
Hmm...I'm not sure, but I had send another patch which changed all
arch/i386 to arch/x86, I think it all be OK.

Thanks
Best regards

> 
> >
> > Thanks
> >>
> >> -Connor


