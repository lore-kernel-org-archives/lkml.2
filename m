Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2ENChv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:37:51 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47195 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2ENChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:37:50 -0400
Message-ID: <1336963067.2154.2.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Mon, 14 May 2012 12:37:47 +1000
In-Reply-To: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 22:25 -0400, Alan Stern wrote:
> Yes, you misunderstand it.

OK, thanks. I did read the rest of your response as well, thanks for the
pointers.

I'll work on redoing the patch with proper prepare to suspend to RAM.

PS. I don't really use user space suspend to both, but whoever is
familiar with it may then have a look at it as well.

-- 
Bojan

