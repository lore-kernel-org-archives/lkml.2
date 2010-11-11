Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0KKTtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:49:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56857 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0KKTtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:49:11 -0500
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
In-Reply-To: <4CDC47C3.3040102@linux.intel.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289502554.2084.153.camel@laptop> <20101111192551.GI18718@basil.fritz.box>
	 <1289504197.2084.172.camel@laptop> <4CDC47C3.3040102@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:49:14 +0100
Message-ID: <1289504954.2084.181.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:45 +0100, Andi Kleen wrote:
> > Can we make it so, that is, move that int inside the intel_percore
> > struct?
> >
> 
> It's needed per cpu. Basically the flag says "bother to look into the 
> percore structure"
> This way most of this is kept out of the fast paths. But one CPU in a core
> may need it and the other not.
> 
> In principle it could be merged into some other cpuc flag word if you 
> have any suggestions. 

Nah, I missed that detail, having it as is seems fine.


