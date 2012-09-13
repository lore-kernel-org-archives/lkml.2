Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2IMPiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:38:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44710 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2IMPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:38:49 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Thu, 13 Sep 2012 17:42:33 +0200
Message-ID: <17733334.UmoCxqVfBu@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201209131608.05869.hverkuil@xs4all.nl>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com> <1347544368-30583-3-git-send-email-federico.vaga@gmail.com> <201209131608.05869.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> typo: steaming -> streaming :-)

fixed

> The header and esp. the source could really do with more
> documentation. It is not at all clear from the code what the
> dma-streaming allocator does and how it differs from other
> allocators.

The other allocators are not documented and to understand them I read 
the code. All the memory allocators reflect a kind of DMA interface: SG 
for scatter/gather, contig for choerent and (now) streaming for 
streaming. So, I'm not sure to understand what do you think is the 
correct way to document a memory allocator; I can write one or two lines 
of comment to summarize each function. what do you think?

-- 
Federico Vaga
