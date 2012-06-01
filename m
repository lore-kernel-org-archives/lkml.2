Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2FAKJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:09:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:49237 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891Ab2FAKJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:09:01 -0400
Message-ID: <1338545330.28384.135.camel@twins>
Subject: Re: [PATCH] sched/x86: Calculate booted cores after construction of
 sibling_mask
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Fri, 01 Jun 2012 12:08:50 +0200
In-Reply-To: <20120601064815.GJ7511@linux.vnet.ibm.com>
References: <20120531073738.GH7511@linux.vnet.ibm.com>
	 <1338496257.28384.121.camel@twins>
	 <20120601064815.GJ7511@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 12:18 +0530, Kamalesh Babulal wrote:
> Will take care of it from next posting.

No need, I queued the fixup...
