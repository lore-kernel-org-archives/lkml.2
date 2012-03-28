Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2C1SFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:05:06 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:45751 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932165Ab2C1SFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:05:04 -0400
Message-ID: <1332957900.2624.38.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <gregkh@linuxfoundation.org>, <haiyangz@microsoft.com>,
        <netdev@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <olaf@aepfle.de>, <linux-kernel@vger.kernel.org>
Date: Wed, 28 Mar 2012 19:05:00 +0100
In-Reply-To: <20120326.191237.2192763107267474232.davem@davemloft.net>
References: <1332800304-5060-1-git-send-email-haiyangz@microsoft.com>
	 <1332800304-5060-2-git-send-email-haiyangz@microsoft.com>
	 <20120326231017.GA30684@kroah.com>
	 <20120326.191237.2192763107267474232.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18802.005
X-TM-AS-Result: No--16.919900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 19:12 -0400, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Mon, 26 Mar 2012 16:10:17 -0700
> 
> > David, please do NOT apply this as-is.
> 
> BTW, ethtool had controls exactly for stuff like this.

Not sure what you're thinking of...?  We have pause frame control but I
don't think that's applicable.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

