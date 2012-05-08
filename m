Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2EHJrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:47:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2EHJrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:47:15 -0400
Message-ID: <1336470398.16236.16.camel@twins>
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Tue, 08 May 2012 11:46:38 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF106@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
	 <1336169422.16236.1.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
	 <1336170586.16236.11.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF103@HQMAIL04.nvidia.com>
	 <1336250117.2463.140.camel@laptop>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF106@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:25 -0700, Diwakar Tundlam wrote:
> I will rework the patch with guidance from other experts.

But please also expand on the actual hardware and its needs. I still
don't understand why you want the CPU domain and not the MC domain. So
explain the physical topology, the way the arm architecture code maps
this to linux topology and how asym_packing helps conserve power.


