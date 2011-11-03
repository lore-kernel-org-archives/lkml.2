Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1KCVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:23:04 -0400
Received: from haggis.mythic-beasts.com ([93.93.131.52]:50272 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1KCVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:23:03 -0400
X-Greylist: delayed 1845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 17:23:03 EDT
Date: Thu, 3 Nov 2011 20:49:36 +0000
From: Luis Henriques <henrix@camandro.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
Message-ID: <20111103204930.GA3599@hades>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
X-BlackCat-Spam-Score: -13
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 11:57:20AM -0400, Miles Lane wrote:
...

I'm hitting the exact same problem, using a minimal .config file (can send
it if required), by just running "find /".

I have bisected the problem and found that commit
aa6afca5bcaba8101f3ea09d5c3e4100b2b9f0e5 seems to be the cause of it.

Cheers,
--
Luis Henriques
