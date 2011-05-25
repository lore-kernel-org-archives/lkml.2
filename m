Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1EYSvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:51:23 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:55911 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1EYSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:51:22 -0400
Date: Wed, 25 May 2011 20:51:05 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Fabio Erculiani <lxnay@sabayon.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbmem: fix race condition between
 register_framebuffer() and fb_open()
Message-ID: <20110525205105.03e2d911@neptune.home>
In-Reply-To: <BANLkTikk2BbOWHQN+UPWD71QoM6g-QpHZg@mail.gmail.com>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
	<BANLkTi=Q5EzN+wP9jDNCxCnZBQ0XHOmOhQ@mail.gmail.com>
	<BANLkTikk2BbOWHQN+UPWD71QoM6g-QpHZg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> On Wed, May 25, 2011 at 8:41 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> >
> > Did you test 2.6.39 ? The fix from Linus is not ok ?
> >
> 
> Sorry, maybe I missed it?

Your patch was against 2.6.39 or shortly before as Linus's code
did introduce the do_ variants of register/unregister/conflict functions.

Bruno
