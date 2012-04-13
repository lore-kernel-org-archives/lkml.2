Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2DMWx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:53:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53803 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2DMWxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:53:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120413190819.9469.qmail@stuge.se>
References: <20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413190819.9469.qmail@stuge.se>
Date: Sat, 14 Apr 2012 01:53:22 +0300
Message-ID: <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:08 PM, Peter Stuge <peter@stuge.se> wrote:
> Felipe Contreras wrote:
>> I guess I should avoid the "stable" series then.
>
> I wish you had understood this much much sooner so that this nonsense
> thread could have been avoided.
>
> If you want the very latest fixes then *obviously* you need to use
> the most bleeding edge repo. (Linus')

No, I don't want the latest fixes, I want the latest *stable* kernel.

v3.3 is stable, v3.4-rcx are not. v3.4 would take months to cook,
there will be several release candidates, and it won't be released
until the known issues decrease to a reasonable level.

v3.3.x on the other hand are *not* stable. They contain patches
backported from v3.4, but nobody guarantees they will work. There was
no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
generally tested together is in v3.3.1, at which point if somebody
finds issues, it's too late; bad patches are *not* going to be removed
in v3.3.2. Once a tag is made, all the patches in it are dependent on
the pace of the development of mainline (v3.4-rcx), which is
definitely not stable, specially in the first release candidates.

IOW, the "stable" branch tries to be stable up to a point, then, it
becomes a testing ground for mainline, and a tracking device for
certain mainline issues.

-- 
Felipe Contreras
