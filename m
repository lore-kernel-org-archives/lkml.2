Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1ALGle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:41:34 -0500
Received: from xenotime.net ([72.52.115.56]:44635 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752112Ab1ALGlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:41:32 -0500
Date: Tue, 11 Jan 2011 22:41:31 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
Message-Id: <20110111224131.f0abcd0a.rdunlap@xenotime.net>
In-Reply-To: <1294800749.29447.2.camel@maxim-laptop>
References: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
	<1294788975-19584-2-git-send-email-maximlevitsky@gmail.com>
	<20110111155124.ee61cd7f.rdunlap@xenotime.net>
	<20110111155511.bcb90254.akpm@linux-foundation.org>
	<20110111155803.5638ec4e.rdunlap@xenotime.net>
	<1294800749.29447.2.camel@maxim-laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 04:52:29 +0200 Maxim Levitsky wrote:


> > >  /**
> > > - * sg_compare_to_buffer - compare contents of the data pointeted by sg table
> > > + * sg_compare_to_buffer - compare contents of the data covered by an sg table
> > >   * to a kernel ram buffer
> > > - * @sg - the current sg entry
> > > - * @buffer - linear buffer to compare with
> > > - * @len - lenght of that buffer
> > > + * @sg: the current sg entry
> > > + * @buffer: linear buffer to compare with
> > > + * @len: length of that buffer
> > 
> > Returns what??
> 0 if equal and 1 otherwise.
> Was too lazy to implement full strcmp compliance.
> Is that needed?

Not that I know of, just what the function returns was needed.


> All very fair comments.
> Will check everything once again.
> Thanks for a review!
> 
> Best regards,
> 	Maxim Levitsky
> 
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
