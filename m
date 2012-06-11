Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2FKOa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:30:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:59726 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2FKOa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:30:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154774988"
Date: Mon, 11 Jun 2012 16:41:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
Message-ID: <20120611144134.GX22557@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339423241.4999.53.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Mon, Jun 11, 2012 at 04:00:41PM +0200, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on the following while fuzzing with trinity inside a KVM tools guest, running on 3.5-rc2:
> 
Thanks for the report, it could be worth adding this one to
bugzilla.kernel.org.

What's trinity ?
Also, if this one is reproducible, would you mind sharing some details about
how we could reproduce it ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
