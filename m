Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2BORY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:24:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:43982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2BORYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:24:25 -0500
Message-ID: <1329326651.2293.151.camel@twins>
Subject: Re: sched: Performance of Trade workload running inside VM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 18:24:11 +0100
In-Reply-To: <20120215171032.GB9918@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
	 <1329307161.2293.66.camel@twins> <20120215171032.GB9918@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 22:40 +0530, Srivatsa Vaddagiri wrote:
> Ok ..let me see if these numbers highlight the problem better.

does this translate like: I've no fscking clue, but my tinker made it go
away?
