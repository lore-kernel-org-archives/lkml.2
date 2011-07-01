Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1GATEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:04:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57805 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab1GATEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:04:09 -0400
Date: Fri, 1 Jul 2011 16:04:04 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth: Rename function bt_err to bt_to_errno
Message-ID: <20110701190404.GE23683@joana>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1309370457.2208.48.camel@aeonflux>
 <cover.1309396408.git.joe@perches.com>
 <895bc01e49b93b9498ca05cfa1bd9cf58cf30df8.1309396408.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <895bc01e49b93b9498ca05cfa1bd9cf58cf30df8.1309396408.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [2011-06-29 18:18:29 -0700]:

> Make it easier to use more normal logging styles later.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/net/bluetooth/bluetooth.h |    2 +-
>  net/bluetooth/hci_core.c          |    2 +-
>  net/bluetooth/l2cap_core.c        |    4 ++--
>  net/bluetooth/lib.c               |    4 ++--
>  net/bluetooth/sco.c               |    4 ++--
>  5 files changed, 8 insertions(+), 8 deletions(-)

I applied this one as well. Thanks.

	Gustavo
