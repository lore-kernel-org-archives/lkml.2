Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781Ab2FHHhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:37:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:33221 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2FHHhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:37:39 -0400
From: Roman Kagan <rkagan@parallels.com>
To: Greg KH <greg@kroah.com>
CC: David Miller <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "tarbal@gmail.com" <tarbal@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "bruce.w.allan@intel.com" <bruce.w.allan@intel.com>,
        "carolyn.wyborny@intel.com" <carolyn.wyborny@intel.com>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "gregory.v.rose@intel.com" <gregory.v.rose@intel.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "john.ronciak@intel.com" <john.ronciak@intel.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jun 2012 11:37:22 +0400
Subject: Re: [PATCH] e1000: save skb counts in TX to avoid cache misses
Thread-Topic: [PATCH] e1000: save skb counts in TX to avoid cache misses
Thread-Index: Ac1FSYz1bbhXFxwpQQmqjHvz/dFCLw==
Message-ID: <1339141042.7850.51.camel@rkaganb.sw.ru>
References: <b838d871c0d507787373061e4edd91a624d62475.1339073391.git.rkagan@parallels.com>
	 <4FD11F49.5060805@gmail.com>
	 <20120607.144358.1732928576389957779.davem@davemloft.net>
	 <20120608021542.GA10112@kroah.com>
In-Reply-To: <20120608021542.GA10112@kroah.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q587bkjR024649

On Fri, 2012-06-08 at 06:15 +0400, Greg KH wrote:
> On Thu, Jun 07, 2012 at 02:43:58PM -0700, David Miller wrote:
> > From: Jeff Kirsher <tarbal@gmail.com>
> > Date: Thu, 07 Jun 2012 14:38:17 -0700
> > 
> > > Thanks! I have applied the patch to my queue
> > 
> > Why?
> > 
> > My impression is that this is a patch already in the tree, and it's
> > being submitted for -stable but such minor performance hacks are
> > absolutely not appropriate for -stable submission.
> 
> The patch description says it is fixing reported oopses,

Exactly.

> but the Subject: isn't all that helpful there.

Well I just preserved the original subject from the upstream commit.
Want me to resubmit with a more alarming one?

> So which is this?  Should I accept it for a stable release or not?

IMO yes ;)

Thanks,
Roman.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
