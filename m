Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3ADN0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:26:11 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63866 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3ADN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:26:08 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Fri, 04 Jan 2013 14:30:44 +0100
Message-ID: <12929800.xFTBAueAE0@harkonnen>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1399400.izKZgEHXnP@harkonnen>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <20130101105217.63d7ca9c@redhat.com> <1399400.izKZgEHXnP@harkonnen>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013 17:13:14 Federico Vaga wrote:
> > After all those discussions, I'm ok on adding this new driver, but please
> > add a summary of those discussions at the patch description. As I said,
> > the reason why this driver is needed is not obvious. So, it needs to be
> > very well described.
> 
> ack. I will ask more information to ST about the board because the
> architecture side it is not in the kernel mainline, but it should be.

I have more information about DMA on the board that I'm using; probably, I can 
make dma-contig work with my device. Unfortunately, I cannot test at the 
moment; I hope to do a test on Monday.


-- 
Federico Vaga
