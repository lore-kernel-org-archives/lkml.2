Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab2IUJyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:54:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:54:24 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/4] v4l: vb2: add prepare/finish callbacks to allocators
Date: Fri, 21 Sep 2012 11:54:31 +0200
Message-ID: <1996811.RHEzVXgiFK@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201209211136.02263.hverkuil@xs4all.nl>
References: <1348219298-23273-1-git-send-email-federico.vaga@gmail.com> <201209211136.02263.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > + * @prepare:	called everytime the buffer is passed from userspace
> > to the
> nitpick: everytime -> every time
> 
> > + *		driver, usefull for cache synchronisation, optional
> > + * @finish:	called everytime the buffer is passed back from the
> > driver
> ditto.
> 

This patch come from here: https://patchwork.kernel.org/patch/1323411/

I send it with my patch set because my work require this patch but it is 
not in the next tree. I think it is convenient to fix the original 
patch, probably it will be integrated in the kernel before this one; so 
this patch will be useless.

Anyway, I will apply this comment fix.

-- 
Federico Vaga
