Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3ACQIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:08:42 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52775 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3ACQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:08:39 -0500
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
Date: Thu, 03 Jan 2013 17:13:14 +0100
Message-ID: <1399400.izKZgEHXnP@harkonnen>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20130101105217.63d7ca9c@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1419875.Bts6eHGtlv@number-5> <20130101105217.63d7ca9c@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After all those discussions, I'm ok on adding this new driver, but please
> add a summary of those discussions at the patch description. As I said,
> the reason why this driver is needed is not obvious. So, it needs to be
> very well described.

ack. I will ask more information to ST about the board because the 
architecture side it is not in the kernel mainline, but it should be.

> Patch 1/4 of this series doesn't apply anymore (maybe it were already
> applied?).

Probably already applied

> So, could you please send us a v4, rebased on the top of staging/for_v3.9
> branch of the media-tree?

I will do it

-- 
Federico Vaga
