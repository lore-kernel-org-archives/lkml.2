Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2IMRx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:53:56 -0400
Received: from tex.lwn.net ([70.33.254.29]:34810 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab2IMRxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:53:54 -0400
Date: Thu, 13 Sep 2012 11:54:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20120913115438.0557462f@lwn.net>
In-Reply-To: <17733334.UmoCxqVfBu@harkonnen>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com>
	<1347544368-30583-3-git-send-email-federico.vaga@gmail.com>
	<201209131608.05869.hverkuil@xs4all.nl>
	<17733334.UmoCxqVfBu@harkonnen>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 17:42:33 +0200
Federico Vaga <federico.vaga@gmail.com> wrote:

> > The header and esp. the source could really do with more
> > documentation. It is not at all clear from the code what the
> > dma-streaming allocator does and how it differs from other
> > allocators.  
> 
> The other allocators are not documented and to understand them I read 
> the code. All the memory allocators reflect a kind of DMA interface: SG 
> for scatter/gather, contig for choerent and (now) streaming for 
> streaming. So, I'm not sure to understand what do you think is the 
> correct way to document a memory allocator; I can write one or two lines 
> of comment to summarize each function. what do you think?

Well, there is some documentation here:

	https://lwn.net/Articles/447435/

This reminds me that I've always meant to turn it into something to put
into Documentation/.  I'll try to get to that soon.

In general, the fact that a subsystem is insufficiently documented is not
a good reason to add more poorly-documented code.  We are, after all,
trying to make the kernel better over time...  

Thanks,

jon
