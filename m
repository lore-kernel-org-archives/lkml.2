Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2GQUES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:65464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab2GQUEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="167580715"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next] mei: use module_pci_driver
Thread-Topic: [char-misc-next] mei: use module_pci_driver
Thread-Index: AQHNZEAJNBqZ1EE3+kOyvdVFhwvAJJct5Tkg
Date: Tue, 17 Jul 2012 20:04:06 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B13C2CD@HASMSX103.ger.corp.intel.com>
References: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com>
 <20120717171726.GA7538@kroah.com>
In-Reply-To: <20120717171726.GA7538@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This patch fails to apply to my tree :(

Right, my mistake I haven't checked it directly with your tree,  I need to wait till you merge the upstream in. 
No rush, it's just a cleanup patch.

Thanks
Tomas
