Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2AEOOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:14:46 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44687 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757491Ab2AEOOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:14:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 4/6] ath6kl: get rid of AR_DBG_LVL_CHECK()
Date: Thu, 5 Jan 2012 14:14:30 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF33@saturn3.aculab.com>
In-Reply-To: <20120105132812.22281.98859.stgit@x201>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 4/6] ath6kl: get rid of AR_DBG_LVL_CHECK()
Thread-Index: AczLrcwZHBdwMIlkSnqTYbXYqmnH3gABjAtw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Kalle Valo" <kvalo@qca.qualcomm.com>, <linville@tuxdriver.com>
Cc: <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
X-OriginalArrivalTime: 05 Jan 2012 14:14:30.0765 (UTC) FILETIME=[576461D0:01CCCBB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> We don't need it as debug calls already have a log level and compiler
> should be smart enough to optimise away the code when ath6kl 
> debug code is not enabled.

Have you checked?
I think you are assuming that because the called
function collapses, the call will be removed allowing
the loop to be removed.
I suspect this is only true if the function is inlined.
IIRC the normal linkage rules mean that only static
functions are candidates for inlining.

	David


