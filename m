Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2GDWdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:33:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55856 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755975Ab2GDWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:33:08 -0400
X-Sasl-enc: YpM5NdTiRkBh6u5scEQFPTIpViyl2OZ4Rtd7ipCujuW4 1341441187
Date: Wed, 4 Jul 2012 19:33:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel e1000 ethernet device, change in kernel v3.4, and jumbo
 frames setting DENIED.
Message-ID: <20120704223305.GB3389@khazad-dum.debian.net>
References: <jt275t$9i2$1@snarked.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jt275t$9i2$1@snarked.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2012, D. Stussy wrote:
> There has been some changes to the driver such that things like
> checksum verification is offloaded from the CPU.  However, this
> blocks the ability to set a jumbo frame.  The kernel does record an
> error indicating that checksum offloading need be disabled fro jumbo
> frame MTU sizes to be used.  My e1000 interfaces use the 82574L
> chipset.
> 
> 1)  Was this an intentional change?

Yes, but I understand Intel is trying to come up with a way not to need it.

> 2)  How do I disable that function so I can set jumbo frames with
> "ifconfig" or "ip"?  I simply don't know what setting I need to
> pass.

ethtool can do it.  Check its manpage, it can manipulate the various NIC
offload engines, as well as other parameters such as dma ring buffer size,
etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
