Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031219Ab2CPNgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:36:22 -0400
Received: from tex.lwn.net ([70.33.254.29]:52992 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030398Ab2CPNgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:36:20 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2012 09:36:20 EDT
Date: Fri, 16 Mar 2012 07:15:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpu_active vs pcrypt & padata
Message-ID: <20120316071556.7a221aac@dt>
In-Reply-To: <1331892788.18960.227.camel@twins>
References: <1331892788.18960.227.camel@twins>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 11:13:08 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Also, wth is all this kernel/padata.c stuff? There's next to no useful
> comment in there and the only consumer seems to be pcrypt, does that
> really need to be in kernel/ ?

FWIW I wrote that stuff up when it went in...

	https://lwn.net/Articles/382257/

Might be helpful in case anybody else thinks they might want to use this
facility.  Maybe.

jon
