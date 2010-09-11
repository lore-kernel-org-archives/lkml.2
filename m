Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0IKAVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:21:06 -0400
Received: from ns2.cypress.com ([157.95.67.5]:34531 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab0IKAVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:21:04 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
References: <1284162665.16135.3.camel@odc-laptop> <20100911001005.GA20027@kroah.com>
Subject: RE: [PATCH] west bridge, Kconfig fix
Date: Fri, 10 Sep 2010 17:20:49 -0700
Organization: Cypress Semiconductor
Message-ID: <B04B456200E54B21903A74C16B359CC8@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: <20100911001005.GA20027@kroah.com>
Thread-Index: ActRRaHWvO4Z4aKuTDOEWj71scBSzwAAI78A
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 

On Fri, Sep 10, 2010 at 04:51:05PM -0700, David Cross wrote:
> > This patch fixes the currently broken Kconfig for west bridge by
> > introducing a dependency on a valid HAL Layer for the driver build.
> > 
> > Signed-off-by: David Cross <david.cross@cypress.com>

> Which order do these 4 patches need to be applied in?  Please read
> section 15 in Documentation/SubmittingPatches for details as to how to
> properly format things.

No ordering is necessary for these specific patches, they are all
independent. 
Re-reading SubmittingPatches document, I am not totally sure if you are
referring to ordering (which is not needed in this case), or the actual
format in section 15. Would you like me to re-submit with a "from", empty
line, and a ":" in the subject?
Please let me know.

Thanks,
david


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

