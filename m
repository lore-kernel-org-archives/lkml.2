Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2FFOpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:45:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57775 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2FFOpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:45:11 -0400
Message-ID: <1338993900.2749.127.camel@twins>
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:45:00 +0200
In-Reply-To: <20120606144132.GJ28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
	 <1338979579.2749.95.camel@twins>
	 <20120606141644.GF28225@tassilo.jf.intel.com>
	 <1338992472.2749.116.camel@twins>
	 <20120606144132.GJ28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:41 -0700, Andi Kleen wrote:

> The reason I avoided it on everyone is that some old chips (NetBurst'ish 
> I think) only were able to read the low 32bits through RDPMC.

Can you verify that? Surely Intel still has one of those space heaters
laying about. If so we need to make the P4 driver do something else.

> Ok. I wasn't aware of that. But it's not merged, what happened to ti?

I forgot about it and queued it instead of your patch, so it should be
'out' there soon.

