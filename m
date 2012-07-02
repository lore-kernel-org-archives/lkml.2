Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab2GBVh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:37:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33035 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2GBVhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:37:24 -0400
Message-ID: <1341265014.23484.47.camel@twins>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction
 profiling on IvyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Date: Mon, 02 Jul 2012 23:36:54 +0200
In-Reply-To: <20120702210008.GB14479@tassilo.jf.intel.com>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	 <1341254598-1379-3-git-send-email-andi@firstfloor.org>
	 <1341256733.23484.11.camel@twins>
	 <20120702195744.GG11413@one.firstfloor.org>
	 <1341260540.23484.25.camel@twins>
	 <20120702210008.GB14479@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 14:00 -0700, Andi Kleen wrote:
> Ok so you want a new flag? Or a new event?

Once we grow the sysfs event stuff for cpu PMUs, we could add a new
named event, but I don't think its all that important.

instructions isn't all that interesting a measure to sample. And the
people that do care can already use it by filling out the event
manually.
