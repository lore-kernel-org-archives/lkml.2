Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1JSHyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:54:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:54656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab1JSHyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:54:46 -0400
Subject: Re: [patch-final] Re: patch] cpusets, cgroups: disallow attaching
 kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Date: Wed, 19 Oct 2011 09:54:32 +0200
In-Reply-To: <1319001860.6222.34.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1319010872.29774.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 07:24 +0200, Mike Galbraith wrote:
> Thanks.  Ok, seems it is decided that this is the best way to deal with
> annoying corner-case.  For convenience, patch with acquired acks below.
> 

Ah, but I'm not rolling over that easily ;-)

I really think that if we want to restrain userspace from doing
something stupid we might as well do something that makes sense, and
that is mandate kthreadd stays in the root group at all times for
everybody.


