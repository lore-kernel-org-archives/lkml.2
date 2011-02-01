Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1BARRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:17:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51138 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1BARRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:17:50 -0500
Subject: Re: kswapd hung tasks in 2.6.38-rc1
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110131231301.GP16981@random.random>
References: <1150342867.83404.1295513748640.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	 <1296507528.7797.4609.camel@nimitz> <1296513616.7797.4929.camel@nimitz>
	 <20110131231301.GP16981@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 01 Feb 2011 09:17:42 -0800
Message-ID: <1296580662.27022.3379.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea,

One more data point: Same kernel binary, but with THP disabled in sysfs,
it ran all night, no problems.

I'll go dig in to it a bit more.

-- Dave

