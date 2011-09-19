Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1ISSh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:37:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44378 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab1ISShJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:37:09 -0400
Subject: Re: [PATCH 3/9] Include nice values in cpuacct
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Mon, 19 Sep 2011 20:36:51 +0200
In-Reply-To: <4E776D31.9090008@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	  <1316030695-19826-4-git-send-email-glommer@parallels.com>
	 <1316449197.6091.6.camel@twins> <4E776D31.9090008@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316457411.6091.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 13:26 -0300, Glauber Costa wrote:
> On 09/19/2011 01:19 PM, Peter Zijlstra wrote:
> > On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> >> Besides user and system.
> >
> >
> > Why!?
> Because this is the whole purpose of this series. Think that in a 
> reasonable use case, each cgroup will be tied to a container system. 
> Each of them wants to have its own statistics, in /proc/stat. The best 
> way I thought of doing it was to piggyback into cpuacct, instead of 
> coming up with a 124th accounting mechanism just for that.
> 
> I also used it do demonstrate how can we easily implement a new feature 
> found in hypervisors out of it, but this is really just the cherry on top.


OK, but then amend the changelog with something like:

Since we want to provide a full /proc/stat equivalent for cgroups, also
implement nice time.
