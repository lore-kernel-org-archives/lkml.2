Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0HRJnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:43:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0HRJnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:43:18 -0400
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Peter Zijlstra <peterz@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C6BA757.7050108@ladisch.de>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
	 <20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de>
	 <4C6B8562.1070902@ladisch.de> <1282121942.1926.3552.camel@laptop>
	 <4C6BA757.7050108@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 11:43:04 +0200
Message-ID: <1282124584.1926.3641.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 11:26 +0200, Clemens Ladisch wrote:
> Anyway, my first patch was crap because the loop isn't actually
> necessary.

Ok, without loop its all fine with me ;-)
