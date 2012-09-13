Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab2IMSLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:11:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45870 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab2IMSLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:11:45 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Thu, 13 Sep 2012 20:14:57 +0200
Message-ID: <2025764.e9gFDuMQWu@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120913115438.0557462f@lwn.net>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com> <17733334.UmoCxqVfBu@harkonnen> <20120913115438.0557462f@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, there is some documentation here:
> 
> 	https://lwn.net/Articles/447435/

I know this, I learned from this page :)

What I'm saying is that I don't know what to write inside the code to 
make it clearer than now. I think is clear, because if you know the 
videobuf2, you know what I'm doing in each vb2_mem_ops. I suppose that 
this is the reason why there are no comments inside the other memory 
allocator. Maybe I am wrong.

-- 
Federico Vaga
