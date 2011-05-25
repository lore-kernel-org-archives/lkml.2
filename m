Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1EYSs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:48:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52488 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1EYSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Q5EzN+wP9jDNCxCnZBQ0XHOmOhQ@mail.gmail.com>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
	<BANLkTi=Q5EzN+wP9jDNCxCnZBQ0XHOmOhQ@mail.gmail.com>
Date: Wed, 25 May 2011 20:48:25 +0200
X-Google-Sender-Auth: DGn6MXyRHBlsD9ffZl0gqC1uaF0
Message-ID: <BANLkTikk2BbOWHQN+UPWD71QoM6g-QpHZg@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix race condition between register_framebuffer()
 and fb_open()
From: Fabio Erculiani <lxnay@sabayon.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:41 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
> Did you test 2.6.39 ? The fix from Linus is not ok ?
>

Sorry, maybe I missed it?

-- 
Fabio Erculiani
