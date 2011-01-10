Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1AJUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:53:44 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:28994 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1AJUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:53:41 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC4BK02rR7Hu/2dsb2JhbACkS3OidJhPhUwEhGeGIw
From: Roland Dreier <rdreier@cisco.com>
To: "J.H." <warthog9@kernel.org>
Cc: David Brown <davidb@codeaurora.org>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>
	<20101220204936.GA21290@huya.qualcomm.com>
	<4D0FFC4B.9050301@kernel.org> <ada62u3dkv2.fsf@cisco.com>
	<adaei8k8ubh.fsf@cisco.com> <4D2B664F.7050106@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Jan 2011 12:53:20 -0800
In-Reply-To: <4D2B664F.7050106@kernel.org> (J. H.'s message of "Mon, 10 Jan
	2011 12:04:31 -0800")
Message-ID: <adasjx07a67.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I haven't added it to 20702 yet as I haven't had time to confirm if it's
 > the same issue, but at first glance it looks it.  My plan is to compile
 > up a mainline kernel, with the above patch, and with debugging turned on
 > and to capture as much as I can from that.

By the way, it is probably a good idea to boot with "slub_debug=FZP" to
make sure that slub debugging is turned on at runtime (unless you're
building at kernel with CONFIG_SLUB_DEBUG_ON=y, which I'm sure Fedora
doesn't do).  The crashes you're seeing definitely look like corruption
in the allocator.

 - R.
