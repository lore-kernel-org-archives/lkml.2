Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab2HQCok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:44:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32775 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab2HQCoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120817022939.GA24650@localhost>
References: <20120713083140.GA19738@localhost>
	<20120713084616.GA20037@localhost>
	<20120717013342.GD21914@kroah.com>
	<20120718051552.GA9124@localhost>
	<20120816172711.GB27415@kroah.com>
	<20120817020608.GA24538@localhost>
	<20120817022939.GA24650@localhost>
Date: Fri, 17 Aug 2012 10:44:37 +0800
Message-ID: <CACVXFVPL4HON7Ec7SxGLgBDJtJExTJihc1cfVQt05WukU54AEQ@mail.gmail.com>
Subject: Re: show_uevent() and general protection fault
From: Ming Lei <tom.leiming@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, devel@driverdev.osuosl.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:29 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:

>
> Something obviously wrong here:
>
>         env->buflen == 12
>         env->envp_idx == 1627389952
>         env->env[0] == NULL
>
> I'm not sure where it comes from, but if it's possible for random

Maybe you can print out the device name by dev_err in show_uevent
under the situation.


Thanks,
-- 
Ming Lei
