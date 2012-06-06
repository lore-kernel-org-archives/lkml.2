Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2FFO2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:28:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:37477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2FFO2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:28:37 -0400
Message-ID: <1338992910.2749.121.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:28:30 +0200
In-Reply-To: <20120606142323.GG28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338979188.2749.92.camel@twins>
	 <20120606141247.GD28225@tassilo.jf.intel.com>
	 <1338992061.2749.111.camel@twins>
	 <20120606142323.GG28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:23 -0700, Andi Kleen wrote:
> 
> But it's very clear this cannot be done without a model check.
> I don't understand how you can even argue against that. 

Who said I fixed it without a model check?

But simply disabling it for a model isn't how you do things. 
