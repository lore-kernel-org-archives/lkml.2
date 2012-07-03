Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2GCMMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:12:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:27553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab2GCMMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118458729"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Roland Dreier <roland@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lekensteyn <lekensteyn@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] misc: mei: set IRQF_ONESHOT for MSI
 request_threaded_irq() in mei_pci_resume()
Thread-Topic: [PATCH] misc: mei: set IRQF_ONESHOT for MSI
 request_threaded_irq() in mei_pci_resume()
Thread-Index: AQHNWPt22ykbOt6//UeebHyDGr2NcZcXd9xQ
Date: Tue, 3 Jul 2012 12:12:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B139911@HASMSX103.ger.corp.intel.com>
References: <15236906.ttExm1X813@al>
 <1341306510-28808-1-git-send-email-roland@kernel.org>
In-Reply-To: <1341306510-28808-1-git-send-email-roland@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Roland Dreier [mailto:roland@purestorage.com] On Behalf Of Roland
> Dreier
> Sent: Tuesday, July 03, 2012 12:09 PM
> To: Winkler, Tomas; Greg Kroah-Hartman; Lekensteyn
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] misc: mei: set IRQF_ONESHOT for MSI
> request_threaded_irq() in mei_pci_resume()
> 
> From: Roland Dreier <roland@purestorage.com>
> 
Thanks but fix was already posted
Tomas
