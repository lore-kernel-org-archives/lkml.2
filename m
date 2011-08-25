Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1HYNJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:09:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:09:11 -0400
Date: Thu, 25 Aug 2011 15:09:07 +0200
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825130907.GO3286@htj.dyndns.org>
References: <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
 <20110823220056.GK3895@n2100.arm.linux.org.uk>
 <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
 <20110823221314.GL3895@n2100.arm.linux.org.uk>
 <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
 <20110825121416.GB8883@n2100.arm.linux.org.uk>
 <20110825121710.GK3286@htj.dyndns.org>
 <20110825122543.GC8883@n2100.arm.linux.org.uk>
 <20110825123542.GM3286@htj.dyndns.org>
 <20110825130414.GE8883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825130414.GE8883@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Russell.

If you can fix it properly without going through temporary step,
that's awesome.  Let's put the arguments behind, okay?

Thanks.

-- 
tejun
