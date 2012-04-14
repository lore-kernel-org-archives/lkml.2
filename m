Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2DNXGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 19:06:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2DNXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 19:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s1aVEDO7TKrVuXoMXP70qAUX-fT-mZOBU92yfn6h3fEQw@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120414094137.54a7f213@stein>
	<CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
	<20120414195559.3d5ab944@stein>
	<CAMP44s0ngzwkbQapTip=oW1b5m2uO5zCzbXHVqHXwT2+Wpgo_A@mail.gmail.com>
	<20120414232124.1ffd7ac9@stein>
	<CAMP44s05k3YkXSLGdYjJ42d+uEM+bLS9uZ+2ztUBWqcO6kyUtA@mail.gmail.com>
	<20120415004714.4d729bef@stein>
	<CAMP44s1aVEDO7TKrVuXoMXP70qAUX-fT-mZOBU92yfn6h3fEQw@mail.gmail.com>
Date: Sat, 14 Apr 2012 19:06:00 -0400
X-Google-Sender-Auth: VE9FCX0gFoK6qQ0J-0GLo6b1l0U
Message-ID: <CAJ-Vmo=LtasH+qiKhbFpWZdHAMocR3_zZ5hr56quAqWu=Qs3gw@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Adrian Chadd <adrian@freebsd.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look, this is getting ridiculous.

I think you're completely wrapped up in the "git" way of thinking about things.

The patch can't be "dropped". It can't be "reverted". It can't be
"removed". All that Linus can do is apply a reversed patch. Then Greg
can sync up however he does it.

You seem completely wrapped up in some misguided notion that the patch
can be dropped from some series of patches. This isn't OpenWRT - you
don't have a directory of a hundred-odd patches. It's a source
revision system, complete with history. You don't remove a patch from
an existing repository - you commit a fix. That may be a reversed
version of the actual commit - but the effect is the same, the change
is "reverted". It just isn't removed from the history.

I think this is done and dusted. :-)


Adrian
