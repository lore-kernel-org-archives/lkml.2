Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1BKNMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:12:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:41731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1BKNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:12:48 -0500
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, balbir@linux.vnet.ibm.com,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
In-Reply-To: <4D5347C9.2030909@cn.fujitsu.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
	 <20110202115012.GA16409@balbir.in.ibm.com>
	 <1296650792.26581.319.camel@laptop>
	 <20110202190251.GB16409@balbir.in.ibm.com>
	 <1297095033.13327.46.camel@laptop>
	 <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com>
	 <1297108959.13327.54.camel@laptop>
	 <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com>
	 <1297160655.13327.92.camel@laptop>  <4D5347C9.2030909@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 13:13:39 +0100
Message-ID: <1297426419.5226.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 10:04 +0800, Li Zefan wrote:
> Since both sched and perf won't use the 2 args @cgrp and @old_cgrp,
> don't bother to change the ->exit interface? 

symmetry with ->attach, both sched and perf use a common method to
implement attach and exit, if one needs it the other would too.



