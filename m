Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab2IMRot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:44:49 -0400
Received: from tex.lwn.net ([70.33.254.29]:34730 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab2IMRor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:44:47 -0400
Date: Thu, 13 Sep 2012 11:45:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20120913114531.4560b3f0@lwn.net>
In-Reply-To: <2107949.TNqhOsq2WF@harkonnen>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com>
	<1347544368-30583-3-git-send-email-federico.vaga@gmail.com>
	<002e01cd91b9$2110d160$63327420$%szyprowski@samsung.com>
	<2107949.TNqhOsq2WF@harkonnen>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 17:46:32 +0200
Federico Vaga <federico.vaga@gmail.com> wrote:

> > A few words explaining why this memory handling module is required or
> > beneficial will definitely improve the commit :)  
> 
> ok, I will write some lines

In general, all of these patches need *much* better changelogs (i.e. they
need changelogs).  What are you doing, and *why* are you doing it?  The
future will want to know.

I'm going to try to look at the actual code, but time isn't something I
have a lot of, still...

Thanks,

jon
