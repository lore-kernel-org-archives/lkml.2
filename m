Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0DMQ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:28:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:21092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0DMQ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,198,1270450800"; 
   d="scan'208";a="508767572"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Steve Wise <swise@opengridcomputing.com>
Date: Tue, 13 Apr 2010 09:28:14 -0700
Subject: RE: Socket Direct Protocol: help (2)
Thread-Topic: Socket Direct Protocol: help (2)
Thread-Index: AcraTaoAP5dQHyzdQbqIjnF2p6VPCAA1vn+A
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
In-Reply-To: <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
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

>I add that in kernel space SDP debug the error is:
>
>command line: dmesg
>sdp_init_qp:95 sdp_sock( 2100:2 40720:0): recv sge's. capability: 4
>needed: 9
>sdp_init_qp:95 sdp_sock( 2100:2 41203:0): recv sge's. capability: 4
>needed: 9
>
>The structure sdp_init_qp() is defined in
>/usr/src/ofa_kernel-1.5.1/drivers/infiniband/ulp/sdp/sdp_cma.c (lines 76
>- 141)

NE020 supports 4 SGEs.  I don't know enough about SDP to know why it is
using this calculation for # of send_sge:

#define SDP_MAX_RECV_SKB_FRAGS (PAGE_SIZE > 0x8000 ? 1 : 0x8000 / PAGE_SIZE)


>Could be a firmware problem?

This is not a firmware problem.

Chien


