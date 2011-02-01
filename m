Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1BARnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:43:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:48714 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1BARnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:43:15 -0500
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1296579641.5081.27.camel@mothafucka.localdomain>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-5-git-send-email-glommer@redhat.com>
	 <4D45649A.4090709@redhat.com>
	 <1296575618.5081.13.camel@mothafucka.localdomain>
	 <1296577030.26581.236.camel@laptop>
	 <1296579641.5081.27.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 18:44:12 +0100
Message-ID: <1296582252.26581.255.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 15:00 -0200, Glauber Costa wrote:
> 
> > What you can do is: steal_ticks = steal_time_clock() / TICK_NSEC, or
> > simply keep a steal time delta and every time it overflows
> > cputime_one_jiffy insert a steal-time tick.
> 
> What do you think about keeping accounting in msec/usec resolution and
> (thus allowing us to compute half a tick to user/system, other half to
> steal time) only change it to cputime in the last minute?

its only accounting full tick..

