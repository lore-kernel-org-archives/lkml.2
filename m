Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1I1S45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:56:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:12322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab1I1S44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:56:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,456,1312182000"; 
   d="scan'208";a="56674399"
From: "Zou, Yi" <yi.zou@intel.com>
To: Michael Chan <mchan@broadcom.com>, Matt Domsch <Matt_Domsch@dell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
Date: Wed, 28 Sep 2011 11:56:42 -0700
Subject: RE: [PATCH] drivers/firmware/edd: Treat "XPRS" host bus type the
 same as "PCI"
Thread-Topic: [PATCH] drivers/firmware/edd: Treat "XPRS" host bus type the
 same as "PCI"
Thread-Index: Acx+CMrUoTnEs+1hRmuBgQaMaPuTPgABa2Pg
Message-ID: <5A9BD224CEA58D4CB62235967D650C160EBFC2A4@orsmsx509.amr.corp.intel.com>
References: <1317162728-14488-1-git-send-email-mchan@broadcom.com>
 <20110928162815.GA14031@emperor.us.dell.com> <1317232279.13696.3.camel@HP1>
In-Reply-To: <1317232279.13696.3.camel@HP1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> On Wed, 2011-09-28 at 09:28 -0700, Matt Domsch wrote:
> > On Tue, Sep 27, 2011 at 05:32:08PM -0500, Michael Chan wrote:
> > > PCI Express devices will return "XPRS" host bus type during BIOS EDD
> > > call.  "XPRS" should be treated just like "PCI" so that the proper
> > > pci_dev symlink will be created.  Scripts such as fcoe-edd.sh will
> > > then work correctly.
> > >
> > > Cc: Matt Domsch <Matt_Domsch@dell.com>
> > > Signed-off-by: Michael Chan <mchan@broadcom.com>
> >
> > Agreed, this looks correct.  Thanks for the patch.  Feel free to
> > submit it through whichever maintainer tree is convenient for you.
> >
> > Reviewed-by: Matt Domsch <Matt_Domsch@dell.com>
> >
> 
> Yi, could you submit this patch through the open-fcoe tree?  Thanks.
> 
Sure, I will pull this into open-fcoe.org's tree and queue it up for next
push to scsi-misc as long as edd folks are ok with it. Just curious, this
is from edd4.0, so might be helpful to point that out in description...
I can fix that when I apply the patch to fcoe-next tree.


yi 

