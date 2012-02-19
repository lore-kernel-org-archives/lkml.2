Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2BSUps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:45:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58834 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2BSUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:45:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of segooon@gmail.com designates 10.204.141.11 as permitted sender) smtp.mail=segooon@gmail.com; dkim=pass header.i=segooon@gmail.com
Date: Mon, 20 Feb 2012 00:40:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: =?utf-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
        lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] task->nsproxy was unexpectedly NULL (caught in exit_shm)
Message-ID: <20120219204023.GA22072@albatros>
References: <CAN8=baycwqAkTJxNpNzaO9G=TbEXeiEYCvWxiwvS+NpLRZi3xw@mail.gmail.com>
 <20120218173950.GA12595@albatros>
 <20120218182436.GB1905@moon>
 <CAN8=bawR0H6y-2qONGdG7CvfgphyeEt1v30YONPf5LaXRdgi+w@mail.gmail.com>
 <20120219201914.GB1895@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120219201914.GB1895@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 00:19 +0400, Cyrill Gorcunov wrote:
> On Sun, Feb 19, 2012 at 08:40:42PM +0100, Przemysław Pawełczyk wrote:
> > A few minutes ago I was closing a tab in Chrome and I heard BEEP!
> > This time my mouse and keyboard stopped responding in X, have to ssh
> > from notebook to read log.
> > (I was using Synergy today, so maybe it is related.)
> > 
> > 
> 
> Hi Przemysław, I'm not -mm expert, so I fear I can't help much in
> -mm related issues, but if I were you I would try to catch this problem
> with nvidia module unloaded and on vanilla kernel (this is debian one,
> right?).

Both nvidia and vbox modules.  VirtualBox is known to be buggy.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
