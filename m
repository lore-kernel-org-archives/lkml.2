Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2CDWh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:37:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61355 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2CDWh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:37:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shawnlandden@gmail.com designates 10.68.240.135 as permitted sender) smtp.mail=shawnlandden@gmail.com; dkim=pass header.i=shawnlandden@gmail.com
Subject: Re: Mimo 720 input 180 deg off, e2i Re: [PATCH] Input:
 usbtouchscreen: add support for Data Modul EasyTouch TP 72037
From: shawn <shawnlandden@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20120304190659.GB22602@core.coreip.homeip.net>
References: <1df92b173fb58c4b6d3091c3eb94d53bf03cfa9e.1330061754.git.viresh.kumar@st.com>
	 <1330064583.2154.340.camel@ssd-ubuntu>
	 <20120224083311.GC18291@core.coreip.homeip.net>
	 <CAJusiZULYGmVCjz_bt4mXB5fbVZZApH1QiCA3F-gjeU-J1tBuA@mail.gmail.com>
	 <20120304190659.GB22602@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 14:37:49 -0800
Message-ID: <1330900669.2452.21.camel@ssd-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-04 at 11:06 -0800, Dmitry Torokhov wrote: 
> On Fri, Feb 24, 2012 at 10:16:40AM -0800, Shawn wrote:
> > Why does the usbtouchscreen.c module have a swap_xy parameter?
> > 
> 
> Historical reasons...
> 
Maybe this, along with the fact that tslib is recommended over
server-xorg-input-evdev should be mentioned in the documentation. That
way others wont try to do the same thing I did, or get confused by the
existance of the swap_xy parameter. Also, if swap_xy is historical than
maybe it should be deprecated, and documented as such.
> 
> And please do not top post.
> 

Shawn

