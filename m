Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2HFHec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:34:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47251 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2HFHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:34:30 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: Update VIP to videobuf2 and control framework
Date: Mon, 06 Aug 2012 09:38:10 +0200
Message-ID: <4296967.xtOULN4YkB@harkonnen>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201208060926.40164.hverkuil@xs4all.nl>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <5055608.KkUHWr6mgc@harkonnen> <201208060926.40164.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I applied all your suggestions, and some extra simplification;
> > [...]

> > ---------------
> > - flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the
> > framework handle the VIDIOC_G/S_PRIORITY ioctls. This requires that
> > you use struct v4l2_fh.
> 
>   ^^^^^^^^^^^^^^^^^^
> 
> Are you using struct v4l2_fh? The version you posted didn't. You need
> this anyway to implement control events.

Yes I'm using it now, it is part of the extra simplification that I did.

-- 
Federico Vaga
