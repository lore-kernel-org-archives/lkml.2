Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2ENHp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:45:28 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:46946 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2ENHpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:45:25 -0400
Message-ID: <1336981522.1678.0.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Mon, 14 May 2012 17:45:22 +1000
In-Reply-To: <1336964335.2154.5.camel@shrek.rexursive.com>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <1336963067.2154.2.camel@shrek.rexursive.com>
	 <1336963613.2154.4.camel@shrek.rexursive.com>
	 <1336964335.2154.5.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 12:58 +1000, Bojan Smojver wrote:
> +               error = pm_suspend(PM_SUSPEND_MEM);

Er, that won't work. The lock is being held by the caller. OK, we'll
have to make it complicated, I guess...

-- 
Bojan

