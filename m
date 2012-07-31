Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2GaU2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:28:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40657 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2GaU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
From: Federico Vaga <federico.vaga@gmail.com>
Date: Tue, 31 Jul 2012 22:27:40 +0200
Message-ID: <CAH5GJ0pfuw=BiEYrwT+P9QVvO5s0QN4nJ5952WPy33=-nT6PBQ@mail.gmail.com>
Subject: Re: Update VIP to videobuf2 and control framework
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use git send-email command to send patches but I think I made a
mistake. If something
is wrong or confused please tell me and I try to resend all the
patches hopefully without mistake. Sorry again.

2012/7/31 Federico Vaga <federico.vaga@gmail.com>:
> As suggested I moved the Video Buffer Input (VIP) of the STA2X11 board to the
> videobuf2. This patch series is an RFC.
>
> The first patch is just an update to the adv7180 because the VIP (the only
> user) now use the control framework so query{g_|s_|ctrl} are not necessery.
>
> The second patch adds a new memory allocator for the videobuf2. I name it
> videobuf2-dma-streaming but I think "streaming" is not the best choice, so
> suggestions are welcome. My inspiration for this buffer come from
> videobuf-dma-contig (cached) version. After I made this buffer I found the
> videobuf2-dma-nc made by Jonathan Corbet and I improve the allocator with
> some suggestions (http://patchwork.linuxtv.org/patch/7441/). The VIP doesn't
> work with videobu2-dma-contig and I think this solution is easier the sg.
>
> The third patch updates the VIP to videobuf2 and control framework. I made also
> some restyling to the driver and change some mechanism so I take the ownership
> of the driver and I add the copyright of ST Microelectronics. Some trivial
> code is unchanged. The patch probably needs some extra update.
> I add the control framework to the VIP but without any control. I add it to
> inherit controls from adv7180.
>



-- 
Federico Vaga
