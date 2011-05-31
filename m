Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1EaF7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:59:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:59044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1EaF7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:59:45 -0400
Subject: Re: Linux 3.0-rc1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 15:59:38 +1000
Message-ID: <1306821578.7481.646.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 18:30 -0700, Linus Torvalds wrote:
> 
> Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> into submission, and get scripts etc cleaned up, and the final release
> should be just "3.0". The -stable team can use the third number for
> their versioning. 

So a bit of bike shedding :-)

Why don't we just keep the 3 digits ? You release 3.x.0 and Greg
increments the last one ?

That means existing tools don't break, and number of digits doesn't
change all the time anymore, less likely to get wrong...

Cheers,
Ben.


