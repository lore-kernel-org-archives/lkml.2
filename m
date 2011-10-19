Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1JSIVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:21:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35908 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466Ab1JSIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:21:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1929V4wLhV2yfGyFYdR5pjQcs52gJQBZXQ2vSN+b3
	+kOUU09u0ucXEK
Subject: Re: [patch-final] Re: patch] cpusets, cgroups: disallow attaching
 kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1319010872.29774.4.camel@twins>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
	 <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
	 <1319001860.6222.34.camel@marge.simson.net>
	 <1319010872.29774.4.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 10:21:04 +0200
Message-ID: <1319012464.6222.67.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 09:54 +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-19 at 07:24 +0200, Mike Galbraith wrote:
> > Thanks.  Ok, seems it is decided that this is the best way to deal with
> > annoying corner-case.  For convenience, patch with acquired acks below.
> > 
> 
> Ah, but I'm not rolling over that easily ;-)

I'm easy.  I committed the global "thou shalt not fiddle with kthreadd"
variant yesterday, and shall wait, quiet like little mouse, for which
ever variant flies.  I bet a nickle I never hear from bugzilla again
even if I forget to replace it with which ever one takes wing :)

	-Mike

