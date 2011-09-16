Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750823Ab1IPAUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 20:20:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:58325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1IPAUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 20:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48967864"
Message-ID: <4E729631.40801@intel.com>
Date: Fri, 16 Sep 2011 08:20:01 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: "rick@microway.com" <rick@microway.com>
CC: Don Zickus <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Houghton <rhoughton@microway.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
References: <201108171751.51648.rick@microway.com>    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>    <20110823171432.GA10794@redhat.com>    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>    <4E547B0F.6000001@intel.com>    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>    <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>    <4E56EA02.7020307@intel.com>    <50815a5ec08cdb713de8eaa92ad6e8b3.squirrel@www.microway.com>    <4E6438DC.4010007@intel.com> <4fc342c27daa84e68a93a59d5206a168.squirrel@www.microway.com>
In-Reply-To: <4fc342c27daa84e68a93a59d5206a168.squirrel@www.microway.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rick,

On 09/16/2011 02:35 AM, rick@microway.com wrote:
> Hi Huang,
> 
> I've been running for a while now with this new patch.  I have not gotten
> any panic output though.  This is the only output I have from GHES:
> 
> [22256.616069] GHES: gar accessed: 0, 0xbf7b9370
> [102115.873369] GHES: gar accessed: 0, 0xbf7b9370
> [175460.888809] GHES: gar accessed: 0, 0xbf7b9370
> [223652.976925] GHES: gar accessed: 0, 0xbf7b9370
> [284678.016631] GHES: gar accessed: 0, 0xbf7b9370
> [321563.363578] GHES: gar accessed: 0, 0xbf7b9370
> [500789.731559] GHES: gar accessed: 0, 0xbf7b9370
> [539808.495653] GHES: gar accessed: 0, 0xbf7b9370
> [545116.419274] GHES: gar accessed: 0, 0xbf7b9370
> [686744.665292] GHES: gar accessed: 0, 0xbf7b9370
> 
> Do you think changing from 5620-5670 cpus changed the behavior?

Don't know why too.

Best Regards,
Huang Ying
