Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1JJQHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:07:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40632 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1JJQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:07:42 -0400
X-Sasl-enc: V3jqdmhotIzhSOZfn9CLK6Pl5TcaqcIr2ai/J0HkDUh4 1318262861
Date: Mon, 10 Oct 2011 07:24:18 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111010142418.GC21944@kroah.com>
References: <20111006190526.GA13883@redhat.com>
 <201110071640.53827.frank.mehnert@oracle.com>
 <CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:58:48AM +0300, Pekka Enberg wrote:
> Hi Frank,
> 
> On Fri, Oct 7, 2011 at 5:40 PM, Frank Mehnert <frank.mehnert@oracle.com> wrote:
> > Please also note that we always have good relations to the open source
> > community so feel free to point me an archive where all these kernel
> > panic reports arrive which you've got. We fixed some bugs in our kernel
> > modules in the past and it is even possible that some of the current
> > bug reports are from older versions of VirtualBox which might have been
> > fixed in the meantime.
> >
> > And of course, helpful and constructive critism is always appreciated.
> 
> What is holding you back from submitting the vbox modules to kernel
> staging tree and starting to clean it up for proper inclusion?

You haven't actually read the vbox kernel code before, have you :)

