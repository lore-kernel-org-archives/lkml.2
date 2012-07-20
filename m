Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GTSeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:34:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53665 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2GTSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:34:05 -0400
Date: Fri, 20 Jul 2012 11:34:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720183400.GL32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342799311.2583.7.camel@twins>
 <20120720170255.GE32763@google.com>
 <1342804877.2583.42.camel@twins>
 <20120720175041.GI32763@google.com>
 <1342808550.2583.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342808550.2583.48.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 20, 2012 at 08:22:30PM +0200, Peter Zijlstra wrote:
> I really think people who use hotplug at high frequencies are on drugs
> and doing it wrong.

I don't know.  It does make some sense.  It's not like we have any
other mechanism to keep some processors completely quiesient, which
could make a noticeable difference from powersaving POV compared to
mostly idle.  Rafael, can you please chime in and explain how / where
/ how freqeuntly / etc CPU hotplug is used for powersaving?

Thanks.

-- 
tejun
