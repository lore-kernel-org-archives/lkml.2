Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1GTMOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:14:25 -0400
Received: from ozlabs.org ([203.10.76.45]:48359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1GTMOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:14:24 -0400
Date: Wed, 20 Jul 2011 22:14:20 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110720221420.153b0830@kryten>
In-Reply-To: <1311158708.5345.12.camel@twins>
References: <20110707102107.GA16666@in.ibm.com>
	<1310036375.3282.509.camel@twins>
	<20110714103418.7ef25b68@kryten>
	<20110714143521.5fe4fab6@kryten>
	<1310649379.2586.273.camel@twins>
	<20110715104547.29c3c509@kryten>
	<1311024956.2309.22.camel@laptop>
	<20110719144451.79bc69ab@kryten>
	<1311070894.13765.180.camel@twins>
	<20110720201436.19e9689a@kryten>
	<1311158708.5345.12.camel@twins>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

> So with that fix the patch makes the machine happy again?

Yes, the machine looks fine with the patches applied. Thanks!

Anton
