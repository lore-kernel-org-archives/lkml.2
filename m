Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423919Ab2LGTOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:14:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab2LGTOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:14:03 -0500
Date: Fri, 7 Dec 2012 15:49:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH -stable 0/1] freezer: PF_FREEZER_NOSIG should be cleared
	along with PF_NOFREEZE
Message-ID: <20121207144901.GA6478@redhat.com>
References: <50BF9CC2.7070705@canonical.com> <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk> <20121206124201.GA30705@redhat.com> <50C10391.4040903@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C10391.4040903@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Joseph Salisbury wrote:
>
> A couple of people have tested your patch and report if fixes the
> suspend/resume bug[0].

Great, thanks a lot.

> Will you be
> requesting this patch in the stable kernels?

I have to ;)

I tried to explain this in the changelog, but once again just in case...

This patch is only for -stable. It is only needed if a) b40a7959 was
backported and b) the kernel still has PF_FREEZER_NOSIG removed in 3.3.

Alernatively, b40a7959 can be reverted. But please note that this will
just hide the problem revealed by "incomplete" b40a7959.

Oleg.

