Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1ALIzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:55:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1ALIzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:55:12 -0500
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <mgalbraith@suse.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 09:55:06 +0100
Message-ID: <1294822506.8370.105.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 14:32 +0800, Yong Zhang wrote:

> Setting rt_runtime both in this patch and the previous one will make tune
> other's rt_runtime/rt_period trouble, I guess.

Hrmph, how annoying.  I'll take another look at rt_runtime.

	-Mike

