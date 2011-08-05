Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1HECx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:53:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:43497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab1HECx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,320,1309762800"; 
   d="scan'208";a="38077252"
From: "Yung, Winson W" <winson.w.yung@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 4 Aug 2011 20:53:17 -0600
Subject: Is there a way to offload everything from cpu0 to other cpus?
Thread-Topic: Is there a way to offload everything from cpu0 to other cpus?
Thread-Index: AcxTGtPEWzDRU2jwSE2juxtwg7sKlQ==
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F124701922F2855@rrsmsx505.amr.corp.intel.com>
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

Hi, I would like to know whether it is possible to offload everything (kernel threads/user apps) to cpu1...x so that I can force cpu0 go into idle?

I can affinity all the interrupt to a different cpu by playing with the /proc/irq/irqx/smp_affinity, how about everything else? 

/Winson.
