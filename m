Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1HXWLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:11:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab1HXWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:11:45 -0400
Date: Wed, 24 Aug 2011 15:11:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-Id: <20110824151115.9499019c.akpm@linux-foundation.org>
In-Reply-To: <20110824150433.70e140a6.rdunlap@xenotime.net>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
	<20110824150433.70e140a6.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 15:04:33 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Wed, 24 Aug 2011 14:09:05 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 3.1-rc3:
> > (patches marked "*" will be included in linux-next)
> 
> Hi Andrew,
> 
> Am I supposed to apply this to linux-next?

Nope.  The full series is based on 3.1-rc3.  It includes origin.patch
which takes it up to current -linus.  And linux-next.patch which takes
it up to today's linux-next.

> I don't get a clean patch(1) against 3.1-rc3.

hm.  What broke?
