Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1C3QDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:03:37 -0400
Received: from fifo99.com ([67.223.236.141]:39514 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab1C3QDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:03:36 -0400
Subject: Re: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
From: Daniel Walker <dwalker@fifo99.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
In-Reply-To: <4D92B43B.5050101@codeaurora.org>
References: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org>
	 <1301426560.4049.0.camel@m0nster>  <4D92B43B.5050101@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 09:03:26 -0700
Message-ID: <1301501006.5346.2.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 21:40 -0700, Jeff Ohlstein wrote:
> Daniel Walker wrote:
> > Are you saying this is mostly a debugging facility ? The interrupts off
> > thing I can see as just debugging, but I don't understand the bus
> > lockups part.
> >   
> 
> It isn't just a debugging facility. It is still beneficial to the end user
> in that it restarts the system if there is a bus lockup or a faulty 
> interrupt
> handler in a rarely used codepath. This is better than the alternative 
> of draining
> the battery and turning off. We want this to be turned on independent of 
> what userspace
> one is using, unless they explicitly turn it off themselves.

It doesn't sound too different that all the other watchdogs in
drivers/watchdog/ .. Your just detecting lockups right?

Daniel

