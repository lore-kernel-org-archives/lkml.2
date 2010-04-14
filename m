Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0DNTYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:24:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:21649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0DNTYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,206,1270450800"; 
   d="scan'208";a="509156067"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       Steve Wise <swise@opengridcomputing.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Date: Wed, 14 Apr 2010 12:24:13 -0700
Subject: RE: Socket Direct Protocol: help (2)
Thread-Topic: Socket Direct Protocol: help (2)
Thread-Index: Acrbr8n2GxICl4CnQSmJJ5mhDyXkDgAVhr8w
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C79BD7D@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
 <4BC49E2B.3000804@opengridcomputing.com>
 <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
 <4BC4D22A.6020700@opengridcomputing.com>
 <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
 <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
In-Reply-To: <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
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

>I work on NE020 cards from February 2010 for an INFN experimental
>proposal, called REDIGO (Read out at 10 Gbits/s), about the data
>acquisition and movement systems. The covergence of storage protocols
>around 10 Gigabits/s Ethernet protocols shows that one way could be the
>Remote Direct Memory Access (RDMA). The goals are the investigations of
>latency time, the throughput, the buffer size schemes and finally the
>global event building bandwidth.
>
>Do you know if NE020 cards have problems with librdma (RDMA procedures,
>in general) and / or with MPI versions?


If you run into any issues, please email me.  NE020 supports Mvapich,
Mvapich2, OpenMPI, Intel MPI and HP MPI.

Chien
