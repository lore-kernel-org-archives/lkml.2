Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0HDAMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab0HDAMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:12:52 -0400
Subject: Re: [PATCH] trivial, document that div64_u64() is not precise on
 32bit platforms
From: Ben Woodard <woodard@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Behlendorf, Brian D." <behlendorf1@llnl.gov>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Mark Grondona <mgrondona@llnl.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100803152812.210439dc.akpm@linux-foundation.org>
References: <20100802160951.GA13385@redhat.com>
	 <20100803152812.210439dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 19:12:41 -0500
Message-ID: <1280880761.10330.5.camel@snog.zork.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Tue, 2010-08-03 at 15:28 -0700, Andrew Morton wrote:
> Well that was a bit lazy of us - I wonder how hard it is to fix.
> 
> At present people will test their code on 64-bit only to find out
> later
> that it doesn't work correctly on 32-bit.  Bad.  Perhaps we should
> similarly break the 64-bit version :)

I just talked to Brian. He's got an implementation that does the
division correctly. He's going to clean it up and send you a patch so
that it will work without losing precision on both 32b and 64b. It is
based upon public domain code from  http://www.hackersdelight.org and
has been proven to be correct in all cases.

-ben


