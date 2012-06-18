Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2FRTXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:23:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:27130 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2FRTXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113439634"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: RE: [ 39/69] iwlwifi: disable the buggy chain extension feature in
 HW
Thread-Topic: [ 39/69] iwlwifi: disable the buggy chain extension feature in
 HW
Thread-Index: AQHNTYc88JtQV79hzUWsBASI7YmJH5cAdC+Q
Date: Mon, 18 Jun 2012 19:23:04 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB316D631@HASMSX103.ger.corp.intel.com>
References: <20120617175941.281333656@decadent.org.uk>
 <20120617175946.829354534@decadent.org.uk>
 <20120618191853.GB3263@herton-Z68MA-D2H-B3>
In-Reply-To: <20120618191853.GB3263@herton-Z68MA-D2H-B3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, this triggers the following build warning:
> linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c: In function
> 'iwl_trans_pcie_tx_start':
> linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:874:2: warning:
> passing argument 1 of 'iwl_write_prph' from incompatible pointer type
> [enabled by default]
> linux-stable/drivers/net/wireless/iwlwifi/iwl-io.h:72:6: note: expected 'struct
> iwl_bus *' but argument is of type 'struct iwl_trans *'
> 
> For 3.2, it should be passed as bus(trans) as other invocations.
> 
> >  	/* Enable DMA channel */
> >  	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
> >  		iwl_write_direct32(bus(trans),
> FH_TCSR_CHNL_TX_CONFIG_REG(chan),

Correct


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

