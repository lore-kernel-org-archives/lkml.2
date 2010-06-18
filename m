Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0FRIVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:21:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:14056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab0FRIVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:21:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,437,1272870000"; 
   d="scan'208";a="809215038"
Subject: TCP stream performance regression due to
 c377411f2494a931ff7facdbb3a6839b1266bcf6
From: "Alex,Shi" <alex.shi@intel.com>
To: eric.dumazet@gmail.com, davem@davemloft.net
Cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 15:17:28 +0800
Message-ID: <1276845448.2118.346.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our netperf testing, TCP_STREAM56 shows about 20% or more performance
regression on WSM/NHM and tigerton machines. The testing boot up both
netserver and client on localhost. The testing command like this:
./snapshot_script_net TC_STREAM56 127.0.0.1 

We found the following commit causes this issue.
c377411f2494a931ff7facdbb3a6839b1266bcf6  
Revert this commit will recover this regression on all machine. 

Regards!
Alex 

