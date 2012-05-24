Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412Ab2EXV11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:27:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab2EXV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:27:24 -0400
Date: Fri, 25 May 2012 03:50:39 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: William Dauchy <wdauchy@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, shli@fusionio.com,
        stable@vger.kernel.org, xen-devel@lists.xensource.com,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
Message-ID: <20120524185039.GA14713@kroah.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
 <20120521181558.GA7829@phenom.dumpdata.com>
 <CAJ75kXbJXVW6dJDzG7zDuiu=6NnTybM3m97gW507-yzzsa7yoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXbJXVW6dJDzG7zDuiu=6NnTybM3m97gW507-yzzsa7yoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:02:26PM +0200, William Dauchy wrote:
> Hello,
> 
> On Mon, May 21, 2012 at 8:15 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > So you are asking for 052b198 to be back-ported.
> > I am OK with that but I think Shaohua needs to Ack that and
> > ask Greg to put it on stable@kernel.org
> 
> Yes, since I didn't find the official process to propose an
> already-in-tree commit to stable@
> (http://kernel.org/doc/Documentation/stable_kernel_rules.txt), I was
> just asking around, maybe to get Shaohua feedback.
> 
> I guess it meets the requirements to be integrated in stable; tested
> on my side in 3.2.x and 3.3.x and fixing a precise issue.

Now applied to the 3.3.x tree, thanks.

greg k-h
