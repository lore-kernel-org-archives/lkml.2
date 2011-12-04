Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1LDENN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 23:13:13 -0500
Received: from science.horizon.com ([71.41.210.146]:61316 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753264Ab1LDENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 23:13:09 -0500
Date: 3 Dec 2011 23:13:05 -0500
Message-ID: <20111204041305.30099.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dhillf@gmail.com, linux@horizon.com
Subject: Re: v3.2-rc2: kernel BUG at mm/migrate.c:578
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBDUyH9BygNQghnjNPr8tf0jCLY2c8scfu_sKZ5goFfPqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following diff is prepared for spotting/catching the triggered bug,
> would you please take another try with it included?

Sure thing.  Thanks for the help!  It's my desktop at work, so
nothing will happen until Monday at the earliest, and it
was several days before triggering before.

You'd like a copy of the (more informative, presumably) kernel
log if it triggers again?  Anything else?

Oh!  I stuffed a lot of extra memory I found lying around in the machine
the other day.  Enough (16G) that a single 32-bit process couldn't
possibly get into trouble.  Should I take it out to increase memory
pressure?
