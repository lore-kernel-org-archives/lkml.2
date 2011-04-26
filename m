Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1DZS6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:58:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab1DZS6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:58:01 -0400
Date: Tue, 26 Apr 2011 11:57:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: dave@linux.vnet.ibm.com, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Subject: Re: [PATCH 2/3] flex_arrays: allow zero length flex arrays
Message-Id: <20110426115713.d9a5c1cd.akpm@linux-foundation.org>
In-Reply-To: <20110426014537.1740.68472.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
	<20110426014537.1740.68472.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 21:45:37 -0400
Eric Paris <eparis@redhat.com> wrote:

> Just like kmalloc will allow one to allocate a 0 length segment of memory
> flex arrays should do the same thing.  It should bomb if you try to use
> something, but it should at least allow the allocation.

Well I suppose that's vaguely sensible, but it adds additional code for
no apparent benefit.

IOW: why?
