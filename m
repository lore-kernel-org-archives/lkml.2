Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0KKMiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:38:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:38394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0KKMh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:37:59 -0500
Subject: Re: [tg_shares_up rewrite v2 10/11] sched: allow update_cfs_load
 to update global load
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: pjt@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        vatsa@in.ibm.com, cfriesen@nortel.com, svaidy@linux.vnet.ibm.com,
        pbourdon@excellency.fr, bharata@linux.vnet.ibm.com, kmr@us.ibm.com,
        balbir@linux.vnet.ibm.com
In-Reply-To: <20101110.205001.226775444.davem@davemloft.net>
References: <20101111035005.443640006@google.com>
	 <20101111035051.156752259@google.com>
	 <20101110.204704.193706279.davem@davemloft.net>
	 <20101110.205001.226775444.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 13:37:54 +0100
Message-ID: <1289479074.2084.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 20:50 -0800, David Miller wrote:

> Please fix all of these build problems, as I want to test your changes
> without all of the group scheduler bloat turned on. 

Won't do much good though, this patch-set is fixing a pure group
scheduler problem.

