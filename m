Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1HXVK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:10:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:24255 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1HXVK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:10:57 -0400
X-IronPort-AV: E=Sophos;i="4.68,277,1312156800"; 
   d="scan'208";a="7431165"
Subject: Re: [PATCH 68/75] hv: netvsc: convert to SKB paged frag API.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>, devel@driverdev.osuosl.org
In-Reply-To: <20110824183010.GG15675@dumpdata.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
	 <1313760467-8598-68-git-send-email-ian.campbell@citrix.com>
	 <20110824183010.GG15675@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 24 Aug 2011 22:10:55 +0100
Message-ID: <1314220255.17978.695.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 14:30 -0400, Konrad Rzeszutek Wilk wrote:
> What is with the 'XXX' ?

Those bits were supposed to be the "net: add support for
per-paged-fragment destructors" patch which I accidentally squashed into
the hv driver.

As I said to Dan they are a reminder referring to the dilemma I
mentioned in the intro mail. Basically that ".p" is ugly because
gl->frags[0].page isn't actually a paged fragment, it's just that this
driver uses skb_frag_t in its internal datastructures.

Ian.


