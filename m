Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1KJMxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:53:52 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:58727 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab1KJMxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:53:51 -0500
Date: Thu, 10 Nov 2011 13:53:47 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111110125347.GA29415@nomi.cz>
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz> <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110114732.GA2217@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stanislaw,

On Thu, Nov 10, 2011 at 12:47:33PM +0100, Stanislaw Gruszka wrote:
> If "dmesg | grep corrupt" will show "Setting corrupt debug order to 1"
> patches are in use. Anyway I need to test the patches locally, to see
> if they work as expected, perhaps exception is generated but call-trace
> is not printed.

It does say that, yes.

> Is this happen only with "Intel Corporation Centrino Advanced-N 6205" or
> with some other adapters?

I don't have any other iwlwifi adapters, so I wouldn't know. The people in
that Ubuntu bugreport have exactly that card as well, but in another notebook.
And they claim it works in newer Ubuntu, but I am running latest kernels with
latest uCode, so I'm out of ideas what else could be wrong.

> > Perhaps it would be cheaper to just get another card in that case.
> > :-)
>
> That will left issue unresolved :-(

Yeah, but considering how few people report this, I'm starting to feel that it
might in fact be a hardware issue. It is unfortunate that the wifi adapter in
this Lenovo model isn't placed in that part of the notebook on the back where
it could be easily replaced. If that was the case, I could easily swap it with
my colleagues without voiding the warranty.

(We've got a lot of Lenovos here, mostly T520 and T420s, most of them running
Fedora, and nobody has reported memory corruption problems. Mine is T420.
Perhaps I should try to connect to this WPA Enterprise using Windows and see
if anything goes wrong. However, I have no clue as to what shall I do to
reproduce the issue in Windows.)

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
