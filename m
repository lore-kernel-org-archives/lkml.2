Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1LAPHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:07:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1LAPHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:07:34 -0500
Message-ID: <1322752032.4699.21.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Date: Thu, 01 Dec 2011 16:07:12 +0100
In-Reply-To: <1322750927.30977.25.camel@frodo>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322750927.30977.25.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 09:48 -0500, Steven Rostedt wrote:
> > For MODULES, using usual static_branch().
> 
> Why not for modules? It can be forced at module load time, and then
> removed. 

Because modules suck, its official now: http://lwn.net/Articles/469801/


