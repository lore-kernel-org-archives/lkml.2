Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2GRHmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:42:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:22390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab2GRHmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179415414"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next] mei: use module_pci_driver
Thread-Topic: [char-misc-next] mei: use module_pci_driver
Thread-Index: AQHNZEAJNBqZ1EE3+kOyvdVFhwvAJJct5Tkg///YqICAAOb8gA==
Date: Wed, 18 Jul 2012 07:42:32 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B143952@HASMSX103.ger.corp.intel.com>
References: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com>
 <20120717171726.GA7538@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B13C2CD@HASMSX103.ger.corp.intel.com>
 <20120717204001.GA18021@kroah.com>
In-Reply-To: <20120717204001.GA18021@kroah.com>
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

> > Right, my mistake I haven't checked it directly with your tree,  I
> > need to wait till you merge the upstream in.
> 
> Merge what "upstream"?

The doesn't apply    because the
 commit a44cab4aff7e72e7052521121fd8ceca51351534
 misc: mei: unregister misc device in pci_remove function
    
is only in Linus' master branch.

 Your branch char-misc-next is still at v3.5-rc2 
I believe that in some point you'll merge the whole Linus' master branch into your char-misc-next branch,
right?

Thanks
Tomas

