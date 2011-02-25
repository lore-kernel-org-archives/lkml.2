Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab1BYWXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:23:49 -0500
Received: from www.tglx.de ([62.245.132.106]:53965 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BYWXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:23:49 -0500
Date: Fri, 25 Feb 2011 23:23:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: File/memory corruption in 2.6.37?
In-Reply-To: <201102251508.45122.thomas@fjellstrom.ca>
Message-ID: <alpine.LFD.2.00.1102252323120.2701@localhost6.localdomain6>
References: <201102251457.51476.thomas@fjellstrom.ca> <201102251508.45122.thomas@fjellstrom.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Thomas Fjellstrom wrote:

> On February 25, 2011, you wrote:
> > Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder indexes
> > are being corrupted fairly regularly. Far more often than is usual (almost
> > never). Several a day in fact are being corrupted. I can only imagine that
> > this isn't the only corruption happening and it is worrying.
> 
> Forgot to give any kind of useful info:
> 
> System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45 intel gfx
> 
> running debian sid, with the current debian 2.6.37 kernel, was running a hand 
> rolled 2.6.36 kernel with autogroup applied and didn't have these issues.

Could you verify that with an hand rolled 2.6.37.2 ?

Thanks,

	tglx
