Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2BUKVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:21:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49458 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2BUKVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:21:19 -0500
Message-ID: <1329819668.2293.383.camel@twins>
Subject: Re: [PATCH v2] sched: Make initial SCHED_RR timeslace RR_TIMESLICE
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 21 Feb 2012 11:21:08 +0100
In-Reply-To: <4F4347DF.2050002@ct.jp.nec.com>
References: <4F3C9995.3010800@ct.jp.nec.com>
	 <1329744653.2293.342.camel@twins> <4F4347DF.2050002@ct.jp.nec.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 16:29 +0900, Hiroshi Shimamoto wrote:
> sounds reasonable.

Thanks!
