Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2IFNV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:21:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2IFNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:21:56 -0400
Date: Thu, 6 Sep 2012 15:21:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
Message-ID: <20120906132150.GE16230@one.firstfloor.org>
References: <20120905102156.9423.27806.stgit@localhost.localdomain> <20120905103237.9726.56131.stgit@localhost.localdomain> <20120905184708.GC16230@one.firstfloor.org> <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com> <20120906122850.GI17289@tassilo.jf.intel.com> <50489853.3050906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50489853.3050906@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even if we decide not to remove these tunables from under their current 
> per-cpu location, I still think it is much cleaner to have them 
> available under /sys/devices/system/machinecheck.

"much cleaner" is not sufficient justification to break an ABI.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
