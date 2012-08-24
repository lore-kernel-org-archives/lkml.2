Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2HXNow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:44:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48732 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2HXNot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:44:49 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/3] [media] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Fri, 24 Aug 2012 15:48:28 +0200
Message-ID: <4043768.GQUlrCiecg@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.2-3.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <027701cd81fe$0ed356a0$2c7a03e0$%szyprowski@samsung.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <1417436.RHVOLNlTxk@harkonnen> <027701cd81fe$0ed356a0$2c7a03e0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can take the patch which adds prepare/finish methods to memory
> allocators. It should not have any dependency on the other stuff from
> that thread. I'm fine with merging it either together with Your patch
> or via Tomasz's patchset, whatever comes first.

Thank you. I'll do the job

-- 
Federico Vaga
