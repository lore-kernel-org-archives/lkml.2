Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1KQCyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:54:15 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:53180 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KQCyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:54:14 -0500
Message-ID: <1321498443.2885.80.camel@deadeye>
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <david.decotigny@google.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>, Tom Herbert <therbert@google.com>
Date: Thu, 17 Nov 2011 02:54:03 +0000
In-Reply-To: <CAG88wWZ853cHkykNbQ+Lqrk_D1p-SCmB0Y29YE6GpSSUORwCxg@mail.gmail.com>
References: <cover.1321481064.git.david.decotigny@google.com>
	 <c7e7b57596f9a06b1c40c8b6e671cc6ac69dd304.1321481064.git.david.decotigny@google.com>
	 <1321485122.2709.55.camel@bwh-desktop>
	 <CAG88wWZ853cHkykNbQ+Lqrk_D1p-SCmB0Y29YE6GpSSUORwCxg@mail.gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18522.005
X-TM-AS-Result: No--19.232200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 17 Nov 2011 02:54:13.0716 (UTC) FILETIME=[304B3940:01CCA4D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 17:54 -0800, David Decotigny wrote:
> On Wed, Nov 16, 2011 at 3:12 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > On Wed, 2011-11-16 at 14:15 -0800, David Decotigny wrote:
> >> This adds a description of RPS/XPS options and allow them to be
> >> changed at make menuconfig time.
> >
> > I'm not sure why you think this is necessary.
> 
> On my copy, make menuconfig doesn't let me change these CONFIG_ items,
> unless I add the string after "boolean", which this patch does. I
> agree, the help I added after is pure cosmetic.
[...]

I know, but I'm asking why you think it's necessary to make them
optional.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

