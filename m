Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1LAQOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:14:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1LAQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:14:11 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5UQAro16S0QA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=I9flj0B8ZdswJex-vcIA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1322751977.4699.20.camel@twins>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322750927.30977.25.camel@frodo>  <1322751977.4699.20.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 11:14:07 -0500
Message-ID: <1322756047.30977.29.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 16:06 +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 09:48 -0500, Steven Rostedt wrote:
> > 
> > I also wonder if this could be used for other things not just init.
> > Maybe at boot up you can determine what hardware is being used, and then
> > decided which path to take. Things that depend on cpuid and such might
> > be able to do such a thing. 
> 
> That sounds suspiciously like alternatives..

Hehe, you caught me ;)

-- Steve



