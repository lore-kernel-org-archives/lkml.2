Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab2CAJe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:34:27 -0500
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:39034 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab2CAJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:34:25 -0500
Date: Thu, 1 Mar 2012 10:33:40 +0100
From: Jesper Nilsson <jesper@jni.nu>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cris/eth_v10: use dev_set_mac_address() instead of
 e100_set_mac_address()
Message-ID: <20120301093339.GG16481@jni.nu>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
 <1330530176-24952-4-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330530176-24952-4-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.249.222.9
X-Scan-Result: No virus found in message 1S32Oa-0003uv-IM.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1S32Oa-0003uv-IM 242cbba952465fc9d07c7f2381a7ee2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 04:42:51PM +0100, Danny Kukawka wrote:
> Use dev_set_mac_address() instead of e100_set_mac_address() directly
> to get validation checks for free.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  drivers/net/cris/eth_v10.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)


/^JN - Jesper Nilsson
