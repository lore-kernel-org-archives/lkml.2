Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0DNSvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab0DNSvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:51:22 -0400
Subject: Re: [REGRESSION PATCH V2] vsprintf: Change struct
 printf_spec.precision from s8 to s16
From: Eric Paris <eparis@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <1271262460.1578.53.camel@Joe-Laptop.home>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
	 <1271262460.1578.53.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 14:50:54 -0400
Message-ID: <1271271054.3042.4.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 09:27 -0700, Joe Perches wrote:
> Commit ef0658f3de484bf9b173639cd47544584e01efa5 changed precision
> from int to s8.
> 
> There is existing kernel code that uses a larger precision.
> 
> An example from the audit code:
> 	vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> which overflows precision and truncates to nothing.
> 
> Extending precision size fixes the audit system issue.
> 
> Other changes:
> 
> Change the size of the struct printf_spec.type from u16 to u8 so
> sizeof(struct printf_spec) stays as small as possible.
> Reorder the struct members so sizeof(struct printf_spec) remains 64 bits
> without alignment holes.
> Document the struct members a bit more.
> 
> Original-patch-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Sorry slow today

Acked-by: Eric Paris <eparis@redhat.com>
Tested-by:
Review-by:
anything else?

