Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab0HEHVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:21:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759830Ab0HEHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:21:27 -0400
Date: Thu, 5 Aug 2010 00:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-Id: <20100805002206.758777aa.akpm@linux-foundation.org>
In-Reply-To: <4C5A64E0.5060807@stericsson.com>
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>
	<20100804125253.3977b0d7.akpm@linux-foundation.org>
	<4C5A64E0.5060807@stericsson.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010 09:14:40 +0200 Philippe Langlais <philippe.langlais@stericsson.com> wrote:

> 
> >>      
> > The patch adds these .set_termios hooks but doesn't actually use them
> > for anything.
> >
> > The changelog doesn't tell us _why_ this was done (it should) and
> > lacking any code to look at it's all a bit mysterious.
> >
> >    
> This feature is used in our U6715 8250 platform serial driver, to avoid
> hack in 8250.c set_termios (Alan Cox requirement).
> In this driver the input uart clock frequency depends on baud rate and
> is computed in our set_termios override function.
> The U6715 paltform serial patch has been submitted on linux-arm mailing 
> list,
> and is ready to enter Russell King Linux tree.

Oh.

> More things to do ?

Update the changelog to include this rather important information.

As the patches are dependent, treat them as a single series.  Russell
can merge them both with Greg's ack or Greg can merge them both with
Russell's ack.

