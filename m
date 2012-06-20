Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2FTQp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:45:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:1425 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2FTQpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:45:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114273230"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: madovsky <infos@madovsky.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: e1000e, 3.4.1, , jumbo frames are not working
Thread-Topic: e1000e, 3.4.1, , jumbo frames are not working
Thread-Index: AQHNTvh0BwMhEmzK90Ss53WzeFK/6JcDZ6Cg
Date: Wed, 20 Jun 2012 16:45:19 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1842846965C@ORSMSX102.amr.corp.intel.com>
References: <loom.20120620T164714-725@post.gmane.org>
In-Reply-To: <loom.20120620T164714-725@post.gmane.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of madovsky
> Sent: Wednesday, June 20, 2012 7:49 AM
> To: linux-kernel@vger.kernel.org
> Subject: RE: e1000e, 3.4.1, , jumbo frames are not working
> 
> it's the same on kernel 3.4.3.
> I can't activate jumbo frames
> my mobo is S5000PAL

This is already known and discussed on previous threads.  If you look at
the system log file you will see a message from the driver which states
"Jumbo frames cannot be enabled  when both receive checksum offload and
receive hashing are enabled.  Disable one of the receive offload features
before enabling jumbos."  A patch that removes this incompatibility is
currently in test here at Intel and should be passed upstream soon.

Thanks,
Bruce.

