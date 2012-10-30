Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2J3FNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab2J3FNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:13:49 -0400
Message-ID: <1351573979.3810.4.camel@turiel>
Subject: Re: Nouveau regression between 3.6 and 3.7-rc3: driver stuck at
 "running init tables"
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 15:12:59 +1000
In-Reply-To: <20121029233237.GA10839@kashmir>
References: <20121029230647.GA10369@kashmir>
	 <1351552559.3810.2.camel@turiel> <20121029233237.GA10839@kashmir>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 00:32 +0100, Mathieu Chouquet-Stringer wrote:
> 	Hi again,
> 
> On Tue, Oct 30, 2012 at 09:15:59AM +1000, Ben Skeggs wrote:
> > Are you able to go back to the current master, and get me a
> > log/screenshot with "nouveau.debug=trace" appended to your kernel
> > options?
> 
> Hmmm I did just that on v3.7-rc3-8-g35fd3dc and it doesn't seem to
> output more stuff:
Hm, the module probably wasn't built with a high enough debug level by
default.  It's alright, we'll come back to that if we need to.

Not sure what's up with the hang yet, however, I noticed the issue [1]
which is likely causing the error messages from nouveau's i2c code.
With some luck, it'll stop triggering whatever bug is making it hang in
the VBIOS init table parser.

Ben.

[1]
http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=000463f13fba6b2f94a5bfcb0d615751ae9c34a0

> 
> http://mathieu.csetco.com/nouveau.jpeg


