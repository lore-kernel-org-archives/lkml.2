Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2GJNmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:42:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab2GJNmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:42:53 -0400
Message-ID: <1341927729.3462.131.camel@twins>
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
Date: Tue, 10 Jul 2012 15:42:09 +0200
In-Reply-To: <CAKfTPtC0BcidJ2ga9c2fdWjrEsfXH48QtSnjv0YOCv7-k3K-Ug@mail.gmail.com>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
	 <1341919622.3462.124.camel@twins>
	 <CAKfTPtC0BcidJ2ga9c2fdWjrEsfXH48QtSnjv0YOCv7-k3K-Ug@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 14:35 +0200, Vincent Guittot wrote:
> 
> May be the last one which enable ARCH_POWER should also go into tip ?
> 
OK, I can take it.
