Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0FBH1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757538Ab0FBH1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:27:34 -0400
Date: Wed, 2 Jun 2010 00:21:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006021523.00357.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <20100602021029.GD10332@jenkins.ifup.org> <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org> <201006021523.00357.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> Moved all the sysfs-exposing stuff to the end just after we put in the
> list (and thus to after the find check).

Yeah, makes more sense that way. No reason to expose anything to sysfs 
early. And splitting it into two patches makes it easier to follow than 
the patch I posted. Ack.

			Linus
