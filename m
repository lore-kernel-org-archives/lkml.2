Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2BQIW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:22:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:28567 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2BQIW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118558084"
Subject: TCP_STREAM performance regression on commit b3613118
From: "Alex,Shi" <alex.shi@intel.com>
To: davem@davemloft.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@intel.com>, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Feb 2012 16:18:14 +0800
Message-ID: <1329466694.12669.2976.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tcp_stream loop back performance has about 10% drop on the
commitment on our core2 2 sockets server. This commit has 2
parents(7505afe28, 5983fe), but both of them have no regression. So
guess the impact just happened when this 2 parents joint. That beyond
our capability to dig it more.

Any ideas? 

Regards! 
Alex 

