Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1BVI5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:57:13 -0500
Received: from ist.d-labs.de ([213.239.218.44]:55147 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1BVI5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:57:11 -0500
Date: Tue, 22 Feb 2011 09:56:48 +0100
From: Florian Mickler <florian@mickler.org>
To: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB=E3=83=AD?=
	=?UTF-8?Q?=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Dave Airlie" <airlied@redhat.com>,
        "Keith Packard" <keithp@keithp.com>
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Message-ID: <20110222095648.11ecbce9@schatten.dmk.lab>
In-Reply-To: <20110222082438.0c0676ca@tux.DEF.witbe.net>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
	<f14qsMvj2tF.A.rQF._fuYNB@chimera>
	<20110222082438.0c0676ca@tux.DEF.witbe.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 08:24:38 +0100
Paul Rolland (ポール・ロラン) <rol@witbe.net> wrote:

> I think you can remove this one from the regression list. I've received an
> update from Florian that said !
> 
> --- Comment #27 from Florian Mickler <florian@mickler.org>  2011-02-20 10:52:15 ---
> According to #22652 "*ERROR* Attempting to mmap a purgeable buffer" warns about
> a userspace error.  
> 
> It links to ticket #22652 in which Chris Wilson indicates this is warning
> about userspace bug, and that this issue is tracked in :
> https://bugs.freedesktop.org/show_bug.cgi?id=31419
> 
> So, this definitely looks like the problem is not in the kernel (though my
> personal view on this is that the message itself should be made much more
> clear and reflect that the problem is not in the kernel, but in userspace).
> 
> Thanks for the tracking you've made,
> Paul
> 

Ok, I'm closing this bug. 

If the error messages go away if you update your userspace (maybe
someone can advise if your versions are 'old', I currently have no
overview of whats current), and you still experience problems (like
those Xserver crashes or freezes), then we should reopen the bug
though. 

Regards,
Flo




