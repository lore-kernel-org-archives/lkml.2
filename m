Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935590Ab1ETJvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:51:19 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:52899 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935557Ab1ETJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:51:14 -0400
Date: Fri, 20 May 2011 11:51:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [RFC][PATCH] maccess,probe_kernel: Make write/read src const
 void *
Message-ID: <20110520095111.GA2439@osiris.boeblingen.de.ibm.com>
References: <1305824936.1465.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305824936.1465.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 01:08:56PM -0400, Steven Rostedt wrote:
> maccess,probe_kernel: Make src const void *
> 
> The functions probe_kernel_write() and probe_kernel_read() do not modify
> the src pointer. Allow const pointers to be passed in without the need
> of a typecast.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 

[...]

>  arch/s390/mm/maccess.c     |    4 ++--

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
