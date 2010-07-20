Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248Ab0GTMNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:13:18 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:4298 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757324Ab0GTMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:13:15 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2010 08:13:15 EDT
Message-ID: <4C458F50.4070200@ixiacom.com>
Date: Tue, 20 Jul 2010 14:58:08 +0300
From: Alex Badea <abadea@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.24) Gecko/20100228 Thunderbird/2.0.0.24 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, Andy Gospodarek <gospo@redhat.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        Casey Leedom <leedom@chelsio.com>, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces
 with random MAC address
References: <4C457F72.8090708@redhat.com> <1279624844.2110.3.camel@achroite.uk.solarflarecom.com> <4C458CB7.3030508@redhat.com>
In-Reply-To: <4C458CB7.3030508@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2010 11:57:59.0351 (UTC) FILETIME=[CC574C70:01CB2802]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/20/2010 02:47 PM, Stefan Assmann wrote:
>> What about devices that 'steal' MAC addresses from slave devices?

Might I suggest an attribute such as "address_type", which could report
"permanent", "random", "stolen", or something else in the future?

My two cents,
Alex
