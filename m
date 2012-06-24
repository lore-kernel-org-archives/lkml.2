Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2FXAlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 20:41:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59903 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537Ab2FXAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 20:40:58 -0400
X-Sasl-enc: MsFuO4JzcwR9Lm4WXDNttcsHdFbzDCFziSTGMoGP4wMQ 1340498457
Date: Sat, 23 Jun 2012 21:40:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] thinkpad_acpi: Convert dbg_printk to tp_dbg and
 tp_vdbg
Message-ID: <20120624004051.GC20885@khazad-dum.debian.net>
References: <cover.1339985626.git.joe@perches.com>
 <d8ab2f07efe50ddd9d3db8612c1cc333cb7e5813.1339985627.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8ab2f07efe50ddd9d3db8612c1cc333cb7e5813.1339985627.git.joe@perches.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012, Joe Perches wrote:
> Use a more current logging style.
> 
> Add #define DEBUG and use pr_debug to enable dynamic debugging.
> Coalesce formats and align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Joe, are there any extra procedures required from the user to get the debug
messages with this patch applied?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
