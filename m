Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0K2S0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:26:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:15487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0K2S0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:26:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,276,1288594800"; 
   d="scan'208";a="631303359"
Message-ID: <4CF3F04F.6090202@linux.intel.com>
Date: Mon, 29 Nov 2010 10:26:23 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>		<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>		<1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>	<1290984809.32570.208.camel@pasglop> <4CF30327.9020408@firmworks.com>
In-Reply-To: <4CF30327.9020408@firmworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2010 05:34 PM, Mitch Bradley wrote:
> 
> The OLPC interface might be of some use as a starting point, but would 
> need some work.  It is currently in use on AMD Geode, Via C7, and Intel 
> Atom based systems, but, among other issues, it conflicts with the 
> Physical Address Extension feature.
> 

It conflicts with at least PAE, PAT and x86-64.  Since NX requires PAE,
it also conflicts with that.  As such, I would think it would have to be
considered obsolete.

	-hpa
