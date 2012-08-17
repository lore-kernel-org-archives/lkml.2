Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab2HQQtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:49:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:51287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2HQQtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:49:07 -0400
Message-ID: <1345222134.29668.63.camel@twins>
Subject: Re: [RFC PATCH 0/1] sched: Add a new API to find the prefer idlest
 cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, vivek@us.ibm.com,
        sri@us.ibm.com
Date: Fri, 17 Aug 2012 18:48:54 +0200
In-Reply-To: <1345217986.16533.1.camel@oc3660625478.ibm.com>
References: <1343026634.13461.15.camel@oc3660625478.ibm.com>
	 <1345217986.16533.1.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 08:39 -0700, Shirley Ma wrote:

> Hello Ingo, Peter,
>         Have you had chance to review below patch?

Well no of course not, nobody CC'ed us..

Your patch submission sucks, you split the changelog and the actual
patch into two different emails.

It doesn't mention who would be calling this and how often. Nor does it
seem to explain where the cpumask arguments come from.

Please try again.
