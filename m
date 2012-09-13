Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab2IMMHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:07:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:43895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab2IMMHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:07:44 -0400
Message-ID: <1347538031.15764.126.camel@twins>
Subject: Re: [PATCH v4 0/5] ARM: topology: set the capacity of each cores
 for big.LITTLE
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yong.zhang0@gmail.com, namhyung@kernel.org, jean.pihet@newoldbits.com,
        mingo@kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Thu, 13 Sep 2012 14:07:11 +0200
In-Reply-To: <CAKfTPtCpZS=ALAjwqX5Wb0j5HjrMjv87MEefGC2O5_p7ENeY2w@mail.gmail.com>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
	 <1341919622.3462.124.camel@twins>
	 <CAKfTPtC0BcidJ2ga9c2fdWjrEsfXH48QtSnjv0YOCv7-k3K-Ug@mail.gmail.com>
	 <1341927729.3462.131.camel@twins>
	 <CAKfTPtCpZS=ALAjwqX5Wb0j5HjrMjv87MEefGC2O5_p7ENeY2w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 11:17 +0200, Vincent Guittot wrote:
> On 10 July 2012 15:42, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2012-07-10 at 14:35 +0200, Vincent Guittot wrote:
> >>
> >> May be the last one which enable ARCH_POWER should also go into tip ?
> >>
> > OK, I can take it.
> 
> Hi Peter,
> 
> I can't find the patch that enable ARCH_POWER in the tip tree. Have
> you take it in your tree ?


Uhmmm.... how about I say I have now? Sorry about that.
