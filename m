Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2LDQDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:03:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:18335 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab2LDQDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:03:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="226434574"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Alan Cox <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: RE: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Thread-Topic: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Thread-Index: AQHN0ihwqEeZmpNWmk6M50CYz937qJgIklqAgAArpVD//+aiAIAAJCKg
Date: Tue, 4 Dec 2012 16:02:17 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01E9DF12@HASMSX106.ger.corp.intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
	<1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
	<20121204143151.1cce530a@pyramind.ukuu.org.uk>
	<5B8DA87D05A7694D9FA63FD143655C1B01E9DED6@HASMSX106.ger.corp.intel.com>
 <20121204153716.322b2cc7@bob.linux.org.uk>
In-Reply-To: <20121204153716.322b2cc7@bob.linux.org.uk>
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

> > > As to overhead. I'd love to see a measurement that can detect the
> > > difference. Do you have a benchmark that shows it ?
> >
> > Don't have any numbers but it seems reasonable to me.
> 
> Processors are pretty good at prediction these days. I've not seen any
> evidence to support the assumption.

I don't have strong opinion about it, yet what would be benefit of keeping the io abstraction layer,
In case we are sure it is not used with io ports?

Anyhow If time permits I will try to run the stress again. 

Greg, can you pleased just drop this patch for now, I don't believe it creates any conflict. 

Thanks
Tomas



