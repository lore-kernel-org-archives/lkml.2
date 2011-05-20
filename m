Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918Ab1ETLB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:01:28 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35175 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934304Ab1ETLB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:01:26 -0400
Date: Fri, 20 May 2011 13:01:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [RFC][PATCH] maccess,probe_kernel: Make write/read src const
 void *
Message-ID: <20110520130121.31a3ef5a@mschwide>
In-Reply-To: <1305824936.1465.4.camel@gandalf.stny.rr.com>
References: <1305824936.1465.4.camel@gandalf.stny.rr.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 13:08:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> maccess,probe_kernel: Make src const void *
> 
> The functions probe_kernel_write() and probe_kernel_read() do not modify
> the src pointer. Allow const pointers to be passed in without the need
> of a typecast.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

