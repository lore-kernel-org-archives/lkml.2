Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1LAPFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:05:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1LAPFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:05:43 -0500
Message-ID: <1322751913.4699.19.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org, Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 01 Dec 2011 16:05:13 +0100
In-Reply-To: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 11:53 +0900, KAMEZAWA Hiroyuki wrote:
> I tried to use jump_label for handling memcg's boot options which sets
> global variable true/false and never changes after boot. And found jump_table
> is larger than expected. This patch is a trial to allow to place jump_table
> in .init section. How do you think ? 

I think its much saner to go help hnaz remove this shadow page table and
thus the need for this stupid boot time param.


