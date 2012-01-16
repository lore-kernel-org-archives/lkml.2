Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2APPWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:22:45 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:53894 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754320Ab2APPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:22:43 -0500
Date: Mon, 16 Jan 2012 10:22:39 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: David Miller <davem@davemloft.net>
Cc: dvhart@linux.intel.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com, tomoya.rohm@gmail.com,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing
 probe
Message-ID: <20120116152239.GA9953@elliptictech.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
 <20120114.001525.2158050844390627233.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120114.001525.2158050844390627233.davem@davemloft.net>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-14 00:15 -0800, David Miller wrote:
> From: Darren Hart <dvhart@linux.intel.com>
> Date: Fri, 13 Jan 2012 22:44:55 -0800
> 
> > CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com> (commit_signer:1/3=33%,commit_signer:1/8=12%)
> 
> BTW, please try to figure out where this "commit_signer" stuff came from.
> 
> It ended up corrupting the CC: list of your posting too.

While it ended up on the CC line, the result is still a valid and
correct email address per RFC 822.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

