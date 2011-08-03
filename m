Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1HCExN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:53:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1HCExI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:53:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jyg4OU3tl2JgxSImUE6o4jqBUnfQzcLcabnvwR75fJXck16wKVpDKuS57B3oEL8QC
	BLetOgA2NmgxD81eBoidg==
Date: Tue, 2 Aug 2011 21:53:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Carpenter <error27@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: openssh-server: sshd (<pid>): /proc/<pid>/oom_adj is deprecated,
 please use /proc/<pid>/oom_score_adj instead.
In-Reply-To: <20110802225825.GE3839@shale.localdomain>
Message-ID: <alpine.DEB.2.00.1108022151490.28467@chino.kir.corp.google.com>
References: <20110514102014.12739.91576.reportbug@eiffel4.mcfm> <20110801122537.GA9469@mwanda> <alpine.DEB.2.00.1108011206130.28986@chino.kir.corp.google.com> <20110802225825.GE3839@shale.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Dan Carpenter wrote:

> Could we do it in a way that made it more clear that the problem was
> an old version of openssh-server and not the kernel?  The information
> is there, but it's overwhelmed in stack trace spam.  Also the kernel
> is tainted now because of sshd.  Maybe the message could include a
> link to a wiki page that told people which version off sshd uses the
> new proc file.
> 

Would you like to ack http://marc.info/?l=linux-kernel&m=131227886118365?
