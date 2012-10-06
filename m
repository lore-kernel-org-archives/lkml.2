Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2JFTKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:10:21 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:53436 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2JFTKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:10:16 -0400
From: Nix <nix@esperi.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: david@lang.hm, Emmanuel Benisty <benisty.e@gmail.com>,
        Kurt H Maier <khm@sdf.org>, linux-kernel@vger.kernel.org
Subject: Re: udev breakages -
References: <fa.90I1W/wmSTgRFXVG67o7Pp3+rKA@ifi.uio.no>
	<fa.Oszo+r/ZqdTxC2FHqqg+CRVMJ5Y@ifi.uio.no>
	<fa.CoxzZZId9dJONv353c+pFG/HO8E@ifi.uio.no>
	<fa.ixJ/7D7BnMK8xp7CwikX7jbmnKU@ifi.uio.no>
	<fa./ubRQE7P/T+ateohnOKdDxOFhL4@ifi.uio.no>
	<fa.lpiFTa5CtuIkUf2Z5eJ0YlsNwYI@ifi.uio.no>
	<20121004145022.GA73321@intma.in>
	<CA+i8gKLMtvsR8_aXiNr_Dh8oBw__pSn__ExzRyjG80f4L1u2ng@mail.gmail.com>
	<alpine.DEB.2.02.1210051316180.13407@asgard.lang.hm>
	<20121005214358.GA12736@khazad-dum.debian.net>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Date: Sat, 06 Oct 2012 20:09:54 +0100
In-Reply-To: <20121005214358.GA12736@khazad-dum.debian.net> (Henrique de
	Moraes Holschuh's message of "Fri, 5 Oct 2012 18:43:58 -0300")
Message-ID: <87y5jjs9h9.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Oct 2012, Henrique de Moraes Holschuh told this:

> On Fri, 05 Oct 2012, david@lang.hm wrote:
>> >On Thu, Oct 4, 2012 at 9:50 PM, Kurt H Maier <khm@sdf.org> wrote:
>> >>On Wed, Oct 03, 2012 at 07:27:01PM +0000, Al Viro wrote:
>> >>>Al, that -><- close to volunteering for maintaining that FPOS kernel-side...
>> >>
>> >>This would be fantastic.
>> >
>> >And that would solve this very much worrying issue [1], quoting:
>> >"(Yes, udev on non-systemd systems is in our eyes a dead end, in case you
>> >haven't noticed it yet. I am looking forward to the day when we can drop
>> >that support entirely.)"
>> >
>> >[1] http://lists.freedesktop.org/archives/systemd-devel/2012-August/006066.html
>> 
>> I think it's worth noting that even though udev 189 was recently
>> released, the not-yet-released Ubuntu 10.10 is going to be including
>> udev 175.
>
> So is Debian.

I'm a bit surprised they didn't stick with 168, really. Even udev 175
requires a /usr mount in the initramfs, and devtmpfs (though the latter
is easy to replace). The former is probably a good idea anyway. The
latter... for any system other than the very largest, or embedded
systems that must boot in a second or less, I can't see a benefit.

-- 
NULL && (void)
