Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab2C1U42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:56:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56440 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2C1U41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:56:27 -0400
Date: Wed, 28 Mar 2012 16:54:17 -0400 (EDT)
Message-Id: <20120328.165417.1083579824641543055.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: gregkh@linuxfoundation.org, haiyangz@microsoft.com, netdev@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332957900.2624.38.camel@bwh-desktop.uk.solarflarecom.com>
References: <20120326231017.GA30684@kroah.com>
	<20120326.191237.2192763107267474232.davem@davemloft.net>
	<1332957900.2624.38.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 13:54:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Wed, 28 Mar 2012 19:05:00 +0100

> On Mon, 2012-03-26 at 19:12 -0400, David Miller wrote:
>> From: Greg KH <gregkh@linuxfoundation.org>
>> Date: Mon, 26 Mar 2012 16:10:17 -0700
>> 
>> > David, please do NOT apply this as-is.
>> 
>> BTW, ethtool had controls exactly for stuff like this.
> 
> Not sure what you're thinking of...?  We have pause frame control but I
> don't think that's applicable.

As I understand this, this situation is really about interrupt flow
control, and for that we have the interrupt moderation ethtool
settings.
