Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1C3DGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 23:06:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:7494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1C3DGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 23:06:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,266,1299484800"; 
   d="scan'208";a="673081163"
Date: Tue, 29 Mar 2011 20:06:06 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Should corrected machine check errors still taint the kernel?
Message-ID: <20110330030606.GA2427@alboin.amr.corp.intel.com>
References: <1301443098.5867.34.camel@w-amax.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301443098.5867.34.camel@w-amax.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 04:58:17PM -0700, Max Asbock wrote:
> I noticed that corrected machine check errors taint the kernel. And it
> looks like they have done that forever.
> 
> Is that still the right thing to do?

Likely not.

> 
> The comment in add_taint() says:
> "Can't trust the integrity of the kernel anymore."

The comment is definitely wrong agreed. 

-Andi
