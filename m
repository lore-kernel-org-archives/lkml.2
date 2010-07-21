Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab0GUNyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:54:44 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:56342 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0GUNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:54:42 -0400
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: David Miller <davem@davemloft.net>, abadea@ixiacom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        leedom@chelsio.com, harald@redhat.com
In-Reply-To: <4C46AB60.5060008@redhat.com>
References: <4C458CB7.3030508@redhat.com>	<4C458F50.4070200@ixiacom.com>
	 <4C4593DA.9040207@redhat.com>
	 <20100720.131839.134093789.davem@davemloft.net>
	 <4C46AB60.5060008@redhat.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Wed, 21 Jul 2010 14:54:38 +0100
Message-Id: <1279720478.2089.3.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2010 13:56:13.0151 (UTC) FILETIME=[7AFD06F0:01CB28DC]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17518.005
X-TM-AS-Result: No--35.101700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 10:10 +0200, Stefan Assmann wrote:
> On 20.07.2010 22:18, David Miller wrote:
> > From: Stefan Assmann <sassmann@redhat.com>
> > Date: Tue, 20 Jul 2010 14:17:30 +0200
> > 
> >> On 20.07.2010 13:58, Alex Badea wrote:
> >>> Hi,
> >>>
> >>> On 07/20/2010 02:47 PM, Stefan Assmann wrote:
> >>>>> What about devices that 'steal' MAC addresses from slave devices?
> >>>
> >>> Might I suggest an attribute such as "address_type", which could report
> >>> "permanent", "random", "stolen", or something else in the future?
> >>
> >> In case there's demand for such a multi-purpose attribute I see no
> >> reason to object. More thoughts on this?
> > 
> > I think this is a great idea.
> > 
> > Now it makes sense to use a new 'u8' in struct netdevice or similar to
> > store this, since we'll have more than a boolean here.
> > 
> 
> I put Alex' idea into code for further discussion, keeping the names
> mentioned here until we agree on the scope of this attribute. When we
> have settled I'll post a patch with proper patch description.
[...]

Just a little nitpick: I think it would be clearer to use a more
specific term like 'address source' or 'address assignment type' rather
than 'address type'.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

