Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0LNVmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:42:54 -0500
Received: from waste.org ([173.11.57.241]:60670 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab0LNVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:42:52 -0500
Subject: Re: [PATCH v3 21/22] netoops: Add user-programmable boot_id
From: Matt Mackall <mpm@selenic.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
In-Reply-To: <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
	 <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 15:42:37 -0600
Message-ID: <1292362957.3446.851.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 13:30 -0800, Mike Waychison wrote:
> Add support for letting userland define a 32bit boot id.  This is useful
> for users to be able to correlate netoops reports to specific boot
> instances offline.

This sounds a lot like the pre-existing /proc/sys/kernel/random/boot_id
that's used by kerneloops.org.

-- 
Mathematics is the supreme nostalgia of our time.


