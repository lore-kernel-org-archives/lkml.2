Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0FAR6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:58:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0FAR6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:58:21 -0400
Date: Tue, 1 Jun 2010 10:53:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011051.25636.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Linus Torvalds wrote:
> 
> So I do agree that your later two-patch series is the way to go.

Oh, btw, did we ever get that version tested by the only person who seems 
to see the problem? Brandon?

I'd like to have a Tested-By: line too.

		Linus
