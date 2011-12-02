Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1LBJYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:24:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1LBJYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:24:39 -0500
Message-ID: <1322817850.4699.69.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org, Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 02 Dec 2011 10:24:10 +0100
In-Reply-To: <20111202092217.50d72f71.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322751913.4699.19.camel@twins>
	 <20111202092217.50d72f71.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 09:22 +0900, KAMEZAWA Hiroyuki wrote:
> 
> 
> Yes, that's an idea. But we also have another stupid shadow swap accounting
> table.  This can be disabled at boot, too. 

Bah I thought it was just the page frame thing, hnaz any plans to kill
this swap array as well?
