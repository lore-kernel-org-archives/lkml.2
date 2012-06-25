Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab2FYREl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:04:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:31672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2FYREi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:04:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="157982443"
Date: Mon, 25 Jun 2012 19:15:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] net: nfc: fix panic in accept()
Message-ID: <20120625171532.GB16275@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy>
 <20120611144134.GX22557@sortiz-mobl>
 <1339425693.6001.2268.camel@edumazet-glaptop>
 <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop>
 <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy>
 <20120611172545.GA1776@redhat.com>
 <CA+1xoqcwr-5dzHvqkt9x0-xj9EFAywVfva=asbHXvX-LSBWqdA@mail.gmail.com>
 <1340639612.10893.84.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340639612.10893.84.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Jun 25, 2012 at 05:53:32PM +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Sasha Levin reported following panic :
I applied a similar patch, more consistent with the rest of the NFC socket
code, still with you as the author. See here:

http://git.kernel.org/?p=linux/kernel/git/sameo/nfc-3.0.git;a=commit;h=631c301f20558525a641fadffc0126affd3dc4a4

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
