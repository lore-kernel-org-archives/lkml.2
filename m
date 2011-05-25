Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1EYSxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:53:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55483 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1EYSxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:53:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110525205105.03e2d911@neptune.home>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
	<BANLkTi=Q5EzN+wP9jDNCxCnZBQ0XHOmOhQ@mail.gmail.com>
	<BANLkTikk2BbOWHQN+UPWD71QoM6g-QpHZg@mail.gmail.com>
	<20110525205105.03e2d911@neptune.home>
Date: Wed, 25 May 2011 20:53:23 +0200
X-Google-Sender-Auth: 1IV00P4O942D92_D8LiIVGtD1Kw
Message-ID: <BANLkTi=5wdmrSCEeHHumcxr5PWXArWtuiw@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix race condition between register_framebuffer()
 and fb_open()
From: Fabio Erculiani <lxnay@sabayon.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:51 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Your patch was against 2.6.39 or shortly before as Linus's code
> did introduce the do_ variants of register/unregister/conflict functions.
>
> Bruno
>

I made that patch against the 2.6.39 tag.
Git ain't lying ;-)

-- 
Fabio Erculiani
