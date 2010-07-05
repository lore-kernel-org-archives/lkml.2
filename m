Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0GEM4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:56:34 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:56652 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0GEM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:56:32 -0400
Date: Mon, 5 Jul 2010 13:55:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-mips@linux-mips.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioc3-eth: Use the instance of net_device_stats from
 net_device.
Message-ID: <20100705125544.GA28849@linux-mips.org>
References: <1278332034-17122-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278332034-17122-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 04:13:51PM +0400, Kulikov Vasiliy wrote:

> Since net_device has an instance of net_device_stats,
> we can remove the instance of this from the adapter structure.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

NACK, your patch doesn't compile.  I'll post a fixed patch in a separate
mail.

  Ralf
