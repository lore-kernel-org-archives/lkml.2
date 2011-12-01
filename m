Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1LAPGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:06:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54896 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1LAPGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:06:40 -0500
Message-ID: <1322751977.4699.20.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Date: Thu, 01 Dec 2011 16:06:17 +0100
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
> 
> I also wonder if this could be used for other things not just init.
> Maybe at boot up you can determine what hardware is being used, and then
> decided which path to take. Things that depend on cpuid and such might
> be able to do such a thing. 

That sounds suspiciously like alternatives..
