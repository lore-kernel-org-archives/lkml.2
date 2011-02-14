Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1BNRXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:23:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:54280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1BNRW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:22:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,469,1291622400"; 
   d="scan'208";a="602517429"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 14 Feb 2011 09:22:49 -0800
Subject: RE: [PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011
Thread-Topic: [PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011
Thread-Index: AcvKle48mzTo4vgcRQ+F0hwa+dmcOwB1c1GA
Message-ID: <4C5E6457CD7911469A07260381288C28D37127C9@orsmsx502.amr.corp.intel.com>
References: <1296680512-2758-1-git-send-email-russ.gorby@intel.com>
 <20110212091913.GD17755@angua.secretlab.ca>
In-Reply-To: <20110212091913.GD17755@angua.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK got it. Thanks.

>-----Original Message-----
>From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant
>Likely
>Sent: Saturday, February 12, 2011 1:19 AM
>To: Gorby, Russ
>Cc: David Brownell; open list:SPI SUBSYSTEM; open list
>Subject: Re: [PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011
>
>On Wed, Feb 02, 2011 at 01:01:51PM -0800, Russ Gorby wrote:
>> Hello SPI maintainers,
>> I am sending a patch for the (new) intel_mid_ssp_spi driver for
>> consideration for inclusion in the Linux Kernel. This is a SPI master
>> controller driver that is being used for the intel MID platform
>(Medfield).
>> It uses the on-board Bulverde SSP controller configured for SPI
>(spibus #3)
>> running at 25Mhz.
>
>Hi Russ,
>
>Just for future reference, when you're only sending one patch, please
>put your notes into the patch description itself, or immediately after
>the --- line.  No need for a cover letter like this one.
>
>Thanks,
>g.

