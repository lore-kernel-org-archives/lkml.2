Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2I2PsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 11:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2I2PsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 11:48:06 -0400
Date: Sat, 29 Sep 2012 17:47:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: GeneralTouch <aroundight77@gmail.com>, yxhma <yxhma@163.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hid:Fix problem on GeneralTouch multi-touchscreen
In-Reply-To: <CAN+gG=G6V_O5W6DCuByAmymeLSvyOtDbsaHTZOqbNgNKu+m6cQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1209291747040.837@pobox.suse.cz>
References: <1348798739-2950-1-git-send-email-aroundight77@gmail.com> <CAN+gG=G6V_O5W6DCuByAmymeLSvyOtDbsaHTZOqbNgNKu+m6cQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Benjamin Tissoires wrote:

> > From: Xianhan Yu <aroundight77@gmail.com>
> >
> > Fix the touch-up no response problem on GeneralTouch twofingers 
> > touchscreen and modify the driver for new GeneralTouch PWT 
> > touchscreen.
> >
> > Signed-off-by: Xianhan Yu <aroundight77@gmail.com>
> 
> Hi,
> 
> Thank you for re-submitting the patch. It's cleaner now.
> 
> I have a few questions, but generally speaking, the patch is good in
> its current form.

Thanks for the review, Benjamin.

> Jiri: I know that I have not been as reactive as I used to, but I'm 
> ending my contract in my current lab now, and I've been pretty busy. 
> Please don't put me in the grave, I'm still the maintainer of 
> hid-multitouch.... ;-)

Glad to hear that :) Perhaps it'd make sense adding yourself to 
MAINTAINERS alongside Henrik?

-- 
Jiri Kosina
SUSE Labs
