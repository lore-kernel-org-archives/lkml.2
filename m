Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2FFKlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:41:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2FFKlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:41:45 -0400
Message-ID: <1338979285.2749.94.camel@twins>
Subject: Re: [perf] exporting perf_pmu_register?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@ghostprotocols.net
Date: Wed, 06 Jun 2012 12:41:25 +0200
In-Reply-To: <alpine.DEB.2.00.1203151737430.15513@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1203151737430.15513@cl320.eecs.utk.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 17:41 -0400, Vince Weaver wrote:
> Would a patch similar to
>   https://lkml.org/lkml/2010/8/18/64
> be accepted that exported this?
> 
If it comes with a patch that uses the exports, sure.
