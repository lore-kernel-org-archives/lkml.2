Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0FDFUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:20:41 -0400
Received: from ozlabs.org ([203.10.76.45]:46980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0FDFUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:20:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Fri, 4 Jun 2010 14:50:37 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006041032.04323.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006031851301.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006031851301.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041450.37611.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 11:25:00 am Linus Torvalds wrote:
> But I suspect that is just myself trying to fool/argue my smarter half 
> into taking it all.

Similar motivation for even asking.

They can stew in linux-next for another cycle: just found a trivial
!SMP compile issue, and with all the other config options in there
it could use some baking...

Thanks,
Rusty.
