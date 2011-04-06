Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1DFSwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:52:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55234 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab1DFSwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:52:38 -0400
Subject: Re: 2.6.39-rc2 boot crash
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110406184753.GA7691@mgebm.net>
References: <20110406184753.GA7691@mgebm.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 06 Apr 2011 11:52:33 -0700
Message-ID: <1302115953.8094.217.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 14:47 -0400, Eric B Munson wrote:
> I am seeing a boot crash on my machine with 2.6.39-rc2.  I don't yet have
> netconsole setup and I don't have serial so the best I can do at the moment
> is a couple of pictures of the stack trace.
> 
> http://tinypic.com/r/2zsr19i/7
> 
> And 
> 
> http://tinypic.com/r/2iw22dj/7
> 
> I will try and get a net console working for better output, is there
> anything else that would help?

This:

> boot_delay=     Milliseconds to delay each printk during boot.
>                         Values larger than 10 seconds (10000) are changed to
>                         no delay (0).
>                         Format: integer

sometimes gives you enough time to get something out of the system.  You
might also want to try and boot the same kernel in a VM.  It might just
be a weird configuration issue, or maybe even a lockdep bug.  If it's
not hardware related, booting in a VM should help a lot.

-- Dave

