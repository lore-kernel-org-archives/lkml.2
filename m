Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2ENCq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:46:56 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35515 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2ENCqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:46:55 -0400
Message-ID: <1336963613.2154.4.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Mon, 14 May 2012 12:46:53 +1000
In-Reply-To: <1336963067.2154.2.camel@shrek.rexursive.com>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <1336963067.2154.2.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 12:37 +1000, Bojan Smojver wrote:
> I'll work on redoing the patch with proper prepare to suspend to RAM.

If I'm reading the source of suspend.c correctly, this would then mean
that instead of calling suspend_devices_and_enter() I should be calling
pm_suspend(), correct?

This function calls enter_state(), which in turn does
prepare/suspend/finish.

-- 
Bojan

