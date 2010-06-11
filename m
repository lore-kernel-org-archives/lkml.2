Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0FKRbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:31:03 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34515 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0FKRbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:31:00 -0400
Date: Fri, 11 Jun 2010 10:30:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] floppy: cleanup patches
Message-ID: <20100611103053.26b6954e@nehalam>
In-Reply-To: <1276152212.13438.4.camel@localhost>
References: <20100609183449.110905403@vyatta.com>
	<1276152212.13438.4.camel@localhost>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 08:43:32 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> Am Mittwoch, den 09.06.2010, 11:34 -0700 schrieb Stephen Hemminger:
> > When going through floppy driver addressing some of the timing
> > bugs, I also saw these leftover things that ought to be cleaned up.
> >   
> 
> With your patches applied on top of 2.6.34 I still get this timeout
> while resuming from ram:

Not clear, did the problem occur before my patches?  The posted set
of patches should not change visible functionalty or fix any observable
bug. Floppy driver would be bug for bug the same.



-- 
