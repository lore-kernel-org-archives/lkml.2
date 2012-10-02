Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2JBMT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:19:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:31412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2JBMT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="228970778"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: How to schedule worker and threaded IRQ on same cpu/core
Thread-Topic: How to schedule worker and threaded IRQ on same cpu/core
Thread-Index: Ac2gmCa8Mz8HGOSiRo6E8/HEDKZlVg==
Date: Tue, 2 Oct 2012 12:19:22 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How can I schedule driver's worker and threaded IRQ on the same core?

For work queue we have schedule_delayed_work_on () API available.
But how to schedule the threaded IRQ on the same core where my worker thread is going to run?

Thanks in Advance.

Thanks,
Ram
