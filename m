Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2BYR1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:27:40 -0500
Received: from ch-smtp04.sth.basefarm.net ([80.76.153.5]:53222 "EHLO
	ch-smtp04.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab2BYR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:27:27 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Feb 2012 12:27:27 EST
Date: Sat, 25 Feb 2012 18:18:06 +0100
From: Jesper Nilsson <jesper@jni.nu>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] cris/eth_v10: check given MAC address, if invalid
 return -EADDRNOTAVAIL
Message-ID: <20120225171805.GB16481@jni.nu>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
 <1330099282-4588-3-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330099282-4588-3-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.249.222.9
X-Scan-Result: No virus found in message 1S1LGu-0001f1-D9.
X-Scan-Signature: ch-smtp04.sth.basefarm.net 1S1LGu-0001f1-D9 c1f9dda59ddb7f4bb16e97554d80be7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 05:01:12PM +0100, Danny Kukawka wrote:
> Check if given address is valid in .ndo_set_mac_address, if
> invalid return -EADDRNOTAVAIL as eth_mac_addr() already does
> if is_valid_ether_addr() fails.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
--
                  Jesper Nilsson -- jesper_at_jni.nu
