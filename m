Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0KKAdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:33:43 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:43170 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0KKAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:33:42 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACbI2kyrR7H+/2dsb2JhbACiPXGkPJtOhUoEhFqFfQ
X-IronPort-AV: E=Sophos;i="4.59,180,1288569600"; 
   d="scan'208";a="246764553"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <greg@kroah.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
	<20101107215908.GA21070@kroah.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 10 Nov 2010 16:33:38 -0800
In-Reply-To: <20101107215908.GA21070@kroah.com> (Greg KH's message of "Sun, 7
	Nov 2010 13:59:08 -0800")
Message-ID: <adar5esn1gd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Isn't the openwrt stuff just drivers and some arch specific code?
 > Nothing that is core infrastructure, and nothing preventing them from
 > submitting the drivers and arch code if they want to, right?

Actually openwrt has some core infrastructure for managing (ethernet)
switches as extra-fancy multiport PHYs.  That means that all the drivers
in openwrt for the typical 5-8 port switches in home routers don't
really apply to mainline.

 - R.
