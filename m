Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0DSPhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:37:48 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:19926 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0DSPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:37:46 -0400
Subject: Re: [PATCH]Add device drivers (GbE, Packet Hub) for Topcliff
From: Ben Hutchings <bhutchings@solarflare.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
       andrew.chih.howe.khor@intel.com, Intel OTC <joel.clark@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
In-Reply-To: <002301cadfbc$ab2e1490$66f8800a@maildom.okisemi.com>
References: <000b01cadd4c$e2f94380$66f8800a@maildom.okisemi.com>
	 <20100416083508.64199657@tpl.lwn.net>
	 <002301cadfbc$ab2e1490$66f8800a@maildom.okisemi.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 19 Apr 2010 16:37:42 +0100
Message-Id: <1271691462.2091.24.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Apr 2010 15:38:15.0142 (UTC) FILETIME=[538FF860:01CADFD6]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17328.005
X-TM-AS-Result: No--21.789900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 21:34 +0900, Masayuki Ohtake wrote:
> Hi jon,
> Thanks for your suggestion again.
> I joined the netdev and send my patch to "netdev <netdev@vger.kernel.org>".
> 
> --
> Hello netdev users,
> 
> I developed the device drivers for Linux kernel 2.6.33-1.
> This time, I added the following drivers
>   - GbE device
>   - Packet HUB device
> 
> The GbE and Packet Hub device drivers are related with each other.
> Because I send patch to LKML <linux-kernel@vger.kernel.org> and the netdev
> <netdev@vger.kernel.org> mailing list.
> 
> Would you check them?
> 
> The patch is uploaded to our WEB site in Sourceforge.net,
> Because the patch size was large.
[...]

Patches must be sent directly to the list for review, with few
exceptions.

The size limit for the list is 100 K.  Given that none of your source
files are this larger, you should be able to split pch_gbe.patch into 3
or more groups of source files, each within this limit.  The changes to
drivers/net/Kconfig and drivers/net/Makefile should be in the last part.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

