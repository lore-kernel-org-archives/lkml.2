Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab2I1RFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:05:33 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:32882 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2I1RFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:05:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: "linux1394-devel@lists.sourceforge.net" 
	<linux1394-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Sep 2012 13:05:28 -0400
Subject: Re: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Thread-Topic: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Thread-Index: Ac2dm3X6hTg/Sz4rSs2FORceFI80tA==
Message-ID: <1348851928.2229.3.camel@thor>
References: <1345359002.6089.3.camel@thor>	<20120819122759.30f9981f@stein>
	 <1345403610.7706.72.camel@thor>	<20120820030450.7f5bfa37@stein>
	 <20120927214436.1da8b8ef@stein>
In-Reply-To: <20120927214436.1da8b8ef@stein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 15:44 -0400, Stefan Richter wrote:
> Date: Sun, 19 Aug 2012 02:50:02 -0400
> From: Peter Hurley <peter@hurleysoftware.com>
> 
> Upper-layer handlers for inbound requests were called with a spinlock
> held by firewire-core.  Calling into upper layers with a lower layer
> lock held is generally a bad idea.
[... snip ...]
> 
> (Changelog rewritten by Stefan R.)
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> Peter, are you OK with the new changelog?

Yes, that's ok with me.

Peter Hurley
