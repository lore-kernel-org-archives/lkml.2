Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2HFIv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:51:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45956 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2HFIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:51:25 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 3/3 v2] [media] sta2x11_vip: convert to videobuf2 and control framework
Date: Mon, 06 Aug 2012 10:55:06 +0200
Message-ID: <2930909.DTsasJxcLr@harkonnen>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201208061042.03658.hverkuil@xs4all.nl>
References: <1343765829-6006-4-git-send-email-federico.vaga@gmail.com> <1344241059-15271-1-git-send-email-federico.vaga@gmail.com> <201208061042.03658.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	vip->video_dev->flags |= V4L2_FL_USES_V4L2_FH |
> > V4L2_FL_USE_FH_PRIO;
> Been there, done that :-)
> 
> V4L2_FL_USE_FH_PRIO is a bit number, not a bit mask. Use set_bit
> instead:
> 
> 	set_bit(V4L2_FL_USE_FH_PRIO, &vip->video_dev->flags);
> 
> No need to set V4L2_FL_USES_V4L2_FH, BTW. That will be set
> automatically as soon as v4l2_fh_open is called.

I saw "unsigned long flags;" in the header but without reading the 
comment :) Thank you. I will test it in these days but I think it's all 
done.

-- 
Federico Vaga
