Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1IERzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:55:36 -0400
Received: from mail.us.es ([193.147.175.20]:55124 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1IERza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:55:30 -0400
Date: Mon, 5 Sep 2011 19:48:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
        gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
        toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, arnd@arndb.de, eparis@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to
 INSTALL_HDR_PATH
Message-ID: <20110905174847.GB32733@1984>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 02:49:44PM -0400, Anthony G. Basile wrote:
> Currently nf_nat.h, nf_conntrack_tuple.h and related headers under
> include/net/netfilter are not installed as part of the public kernel
> headers.   However, there are userland applications, other than iptables
> which ships with its own headers, which need these to make use of NAT in
> the kernel's netfilter API.  For example, miniupnpd, requires them and is
> forced to search /usr/src/linux when building.

Could anyone clarify why miniupnpd (or any other application) require
this?

Those headers contain structure layouts that may change along time
without further notice, thus breaking backward compatibility.

and BTW, no need to cross-post this message to such a huge list of CC.
I guess you could simply use netfilter-devel for this.
