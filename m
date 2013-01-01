Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3AAMxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 07:53:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3AAMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 07:53:05 -0500
Date: Tue, 1 Jan 2013 10:52:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130101105217.63d7ca9c@redhat.com>
In-Reply-To: <1419875.Bts6eHGtlv@number-5>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
	<1535483.0HokefWAdm@harkonnen>
	<50D080B6.1020109@samsung.com>
	<1419875.Bts6eHGtlv@number-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

Em Thu, 20 Dec 2012 16:37:50 +0100
Federico Vaga <federico.vaga@gmail.com> escreveu:

> > I can take a look at the dma coherent issues with that board, but I 
> will
> > need some help as I don't have this hardware.
> 
> I have the hardware, but I don't have the full knowledge of the 
> boards. As I told before, I asked to windriver which develop the 
> software for the whole board, but they cannot help me.
> 

After all those discussions, I'm ok on adding this new driver, but please
add a summary of those discussions at the patch description. As I said,
the reason why this driver is needed is not obvious. So, it needs to be
very well described.

Your new "v3 3/4" patch seems OK on my eyes (I can't test it, as I don't
have the hardware). Yet, there was one merge conflict on it.

Patch 1/4 of this series doesn't apply anymore (maybe it were already
applied?).

So, could you please send us a v4, rebased on the top of staging/for_v3.9
branch of the media-tree?

Thanks!
Mauro
