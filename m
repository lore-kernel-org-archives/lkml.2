Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1FUIFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 04:05:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:58571 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1FUIFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 04:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wWcyfnKYBz4ABZgJ7BfqoP2/oyDVXD6duLr/pzlDqY+gd3sNDNQgMUZr/j9wCtsr/K
         dVJGlAL7R1vNjfj+w8BEuWCY7xlA8719eHBHKANN2k0TYzxJjPZjO25nGnO04/6sMiWE
         qYwhQiI7jvD4+dkqrXXUwZZFlsF3CwZgZJXfs=
MIME-Version: 1.0
In-Reply-To: <20110621001805.1caecc82@queued.net>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
	<BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
	<1308631634.31157.7.camel@dcbw.foobar.com>
	<20110621001805.1caecc82@queued.net>
Date: Tue, 21 Jun 2011 09:05:33 +0100
X-Google-Sender-Auth: 89CejdKdnHNEKopqe3GoUmOshnk
Message-ID: <BANLkTi=CPEmFVbwuSBSsQjv4ZqHX+Ng8gw@mail.gmail.com>
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Dan Williams <dcbw@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        cjb@laptop.org, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 June 2011 08:18, Andres Salomon <dilinger@queued.net> wrote:
> Looks like the one on dev.l.o is older (9.70.7.p0).  Shall I redo the
> pull request a) ignoring sd8686, b) replacing usb8388 v5 with the OLPC
> version, and c) including both thinfirm blobs as well, then?

That sounds good to me. The only thing I'm a bit unsure about is the
usb8388 thing. If you replace usb8388_v5.bin with the latest OLPC one,
we would like to have that at the top of the list, higher than
usb8388_v9, so that OLPC firmware gets preferred. That might be a bit
strange. On the other hand, if usb8388_olpc_v5.bin is at the top its
less odd, since it looks like a separate branch.

The other changes look fine, and we will figure out sd8686 and send a
later pull request for that. Dan, can you send over
SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64, and any release
notes/changelog you may have? I wasn't aware of this release.

Thanks,
Daniel
