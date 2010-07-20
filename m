Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259Ab0GTMRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:17:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab0GTMRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:17:42 -0400
Message-ID: <4C4593DA.9040207@redhat.com>
Date: Tue, 20 Jul 2010 14:17:30 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Alex Badea <abadea@ixiacom.com>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, Andy Gospodarek <gospo@redhat.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        Casey Leedom <leedom@chelsio.com>, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces
 with random MAC address
References: <4C457F72.8090708@redhat.com> <1279624844.2110.3.camel@achroite.uk.solarflarecom.com> <4C458CB7.3030508@redhat.com> <4C458F50.4070200@ixiacom.com>
In-Reply-To: <4C458F50.4070200@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.2010 13:58, Alex Badea wrote:
> Hi,
> 
> On 07/20/2010 02:47 PM, Stefan Assmann wrote:
>>> What about devices that 'steal' MAC addresses from slave devices?
> 
> Might I suggest an attribute such as "address_type", which could report
> "permanent", "random", "stolen", or something else in the future?

In case there's demand for such a multi-purpose attribute I see no
reason to object. More thoughts on this?

Thanks for your suggestion Alex.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
