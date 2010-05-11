Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab0EKKPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 06:15:38 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:51081 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab0EKKPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:15:33 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 06:15:33 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=avt4F7fjhQYwezVBFK1FiA0Ynk5H+0wGhG0h5fCX74nEtj3J311oOsCvphjdYAbjgD
         G3Ojb0oZ5BuLBHpxaUrKZ86BJjmoJ7ZInzv2uPDFtibrQYCmaA5L53/YIu/IpZOxgCkl
         UwMTEXFVc1wYwKg9uW4a9j+P73vjZyl6fOtqM=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4BE8931C.9070106@linux.vnet.ibm.com>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com>
Date: Tue, 11 May 2010 12:09:06 +0200
Message-ID: <g2h7c86c4471005110309rf886837bu3578717edc89153b@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey,

On Tue, May 11, 2010 at 1:13 AM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> We'd like to have the capability of hardware-specific symbolic event names in the perf tool by some mechanism, unified or otherwise.  Right now, for the IBM Wire-Speed processor, we are currently not able to use the perf tool because of its lack of symbolic raw event name support.
>
> In the mean time, we are using a pair of demo programs from Stephane Eranian's libpfm4 source tree called "task" and "syst".  These tools use the symbolic event names provided by libpfm4, and use the kernel support from perf_events.
>
I will soon post a patch to make use of libpfm4 in perf, thereby
giving access to all events
unit masks, filters, using symbolic names.
