Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0KLDRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:17:14 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:35169 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0KLDRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:17:13 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPJA3EyrR7Ht/2dsb2JhbACiTHGkOJsehUoEhFqFfg
X-IronPort-AV: E=Sophos;i="4.59,186,1288569600"; 
   d="scan'208";a="380135503"
From: Roland Dreier <rdreier@cisco.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Greg KH <greg@kroah.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<adar5esn1gd.fsf@cisco.com> <20101111004730.GC22463@kroah.com>
	<201011111221.09237.florian@openwrt.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 11 Nov 2010 19:17:12 -0800
In-Reply-To: <201011111221.09237.florian@openwrt.org> (Florian Fainelli's
	message of "Thu, 11 Nov 2010 12:21:08 +0100")
Message-ID: <adasjz7kz7r.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Why can't we merge that core infrastructure as well?  Has it been
 > rejected for any specific reasons?

There's nothing obviously wrong with it, and I didn't mean to suggest
that there would be a problem merging it.  I was just pointing out that
openwrt has done a bit more than just drivers and arch code.

 - R.
