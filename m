Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0HEJBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:01:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab0HEJA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:00:57 -0400
Date: Thu, 5 Aug 2010 02:00:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-Id: <20100805020040.48c45207.akpm@linux-foundation.org>
In-Reply-To: <4C5A7B93.9020106@stericsson.com>
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>
	<20100804125253.3977b0d7.akpm@linux-foundation.org>
	<4C5A64E0.5060807@stericsson.com>
	<20100805002206.758777aa.akpm@linux-foundation.org>
	<4C5A7B93.9020106@stericsson.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010 10:51:31 +0200 Philippe Langlais <philippe.langlais@stericsson.com> wrote:

> >> More things to do ?
> >>      
> > Update the changelog to include this rather important information.
> >    
> Ok is done
> > As the patches are dependent, treat them as a single series.  Russell
> > can merge them both with Greg's ack or Greg can merge them both with
> > Russell's ack.
> >
> >    
> This patch can be merged before U6715 platform one without problem.
> Where I post the series in linux-kernel or linux-arm or both mailing lists ?

Both.

> Greg has already taken this patch in its linux-next tree, need to resend 
> to him the patch with new comments ?

Sure, Greg can probably update the changelog.

> All U6715 platform patches are already posted in linux-arm mailing list.
> It's my first contribution and I don't know how to proceed.

I'd suggest that Greg merge both patches.  The patch he has at present
doesn't do anything useful.
