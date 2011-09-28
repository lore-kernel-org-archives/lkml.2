Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1I1SCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:02:16 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1477 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab1I1SCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:02:15 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [PATCH] drivers/firmware/edd: Treat "XPRS" host bus type
 the same as "PCI"
From: "Michael Chan" <mchan@broadcom.com>
To: "Matt Domsch" <Matt_Domsch@dell.com>, yi.zou@intel.com
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
In-Reply-To: <20110928162815.GA14031@emperor.us.dell.com>
References: <1317162728-14488-1-git-send-email-mchan@broadcom.com>
 <20110928162815.GA14031@emperor.us.dell.com>
Date: Wed, 28 Sep 2011 10:51:19 -0700
Message-ID: <1317232279.13696.3.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 629DBD105IS13191521-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2011-09-28 at 09:28 -0700, Matt Domsch wrote:
> On Tue, Sep 27, 2011 at 05:32:08PM -0500, Michael Chan wrote:
> > PCI Express devices will return "XPRS" host bus type during BIOS EDD
> > call.  "XPRS" should be treated just like "PCI" so that the proper
> > pci_dev symlink will be created.  Scripts such as fcoe-edd.sh will
> > then work correctly.
> > 
> > Cc: Matt Domsch <Matt_Domsch@dell.com>
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> 
> Agreed, this looks correct.  Thanks for the patch.  Feel free to
> submit it through whichever maintainer tree is convenient for you.
> 
> Reviewed-by: Matt Domsch <Matt_Domsch@dell.com>
> 

Yi, could you submit this patch through the open-fcoe tree?  Thanks.


