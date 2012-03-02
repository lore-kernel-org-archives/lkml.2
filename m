Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab2CBLes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:34:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:45175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2CBLeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:34:46 -0500
Message-ID: <1330688075.11248.230.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Fri, 02 Mar 2012 12:34:35 +0100
In-Reply-To: <4F50AEC3.5090807@redhat.com>
References: <20120221211938.GE12236@google.com>
	    <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	    <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	   <4F4FAF89.3090706@redhat.com> <1330624986.11248.209.camel@twins>
	  <4F50AA22.9080007@redhat.com> <1330687394.11248.222.camel@twins>
	 <4F50AEC3.5090807@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 12:28 +0100, Michal Schmidt wrote:
> On 03/02/2012 12:23 PM, Peter Zijlstra wrote:
> > On Fri, 2012-03-02 at 12:08 +0100, Michal Schmidt wrote:
> >> It's recommended not to do that and nobody actively
> >> tests this setup, but at least systemd will not abort. So it can be used
> >> to check if the kernel boots and to run some tests.
> >
> > So you don't recommend people use server type setups? Quality
> > engineering that!
> 
> I don't follow. Are you saying that CONFIG_CGROUPS=y is incompatible 
> with server setups?

It is for mine, I don't need it, not building it gives a smaller kernel
and thus less attack/bug surface. 
