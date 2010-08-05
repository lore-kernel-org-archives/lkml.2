Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab0HEMvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:51:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:52981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab0HEMvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,321,1278313200"; 
   d="scan'208";a="308543687"
From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz@intel.com>
To: Or Gerlitz <ogerlitz@voltaire.com>
CC: Roland Dreier <rdreier@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date: Thu, 5 Aug 2010 13:51:20 +0100
Subject: RE: InfiniBand/RDMA merge plans for 2.6.36
Thread-Topic: InfiniBand/RDMA merge plans for 2.6.36
Thread-Index: Acs0mbGgsP/PWEZFTJeYiZMw+qYw2QAAUjqw
Message-ID: <BE2BFE91933D1B4089447C64486040805BD8392A@irsmsx503.ger.corp.intel.com>
References: <adak4o654x9.fsf@roland-alpha.cisco.com>
 <BE2BFE91933D1B4089447C64486040805BD838C4@irsmsx503.ger.corp.intel.com>
 <4C5AAE5F.2080008@voltaire.com>
In-Reply-To: <4C5AAE5F.2080008@voltaire.com>
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

Hello Or, 
My patch was implemented using the most effective method available for current version of code and it is ready and working as a functionality. 

For me another thing then functionality is an optimization of the existing SW paths in infiniband code and modification earlier written code to new interfaces. 

Tomorrow I will start a new discussion regarding an optimization of the post_send/post_recv path. Thank you for reminder.

Regards,

Mirek

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz@voltaire.com] 
Sent: Thursday, August 05, 2010 2:28 PM
To: Walukiewicz, Miroslaw
Cc: Roland Dreier; linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.36

Walukiewicz, Miroslaw wrote:
> Hello Roland,  What about a series from Aleksey Senin [...] And my patch RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes driver https://patchwork.kernel.org/patch/110252
Hi Mirek,

Reading your response @ http://marc.info/?l=linux-rdma&m=127954552519544 
to the comments made during the review, I was under the impression that 
you're going to try and modify the NES implementation, isn't this the 
case any more?

Or.
