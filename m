Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2FNW22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:28:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2FNW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:28:27 -0400
Date: Thu, 14 Jun 2012 15:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Wagin <avagin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: general protection fault on finalizing task
Message-Id: <20120614152826.8385ca30.akpm@linux-foundation.org>
In-Reply-To: <CANaxB-yO0Sdt_JTHDHJCaT6OHMgBBg09Qc+6_SHWMeeXHXDGWw@mail.gmail.com>
References: <CANaxB-xyBw+O9h7OrFRNM93+Gp+GX63C-OgOZ2ZK2QbKMDBJ7g@mail.gmail.com>
	<20120614160129.GA3433@redhat.com>
	<CANaxB-yO0Sdt_JTHDHJCaT6OHMgBBg09Qc+6_SHWMeeXHXDGWw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 01:05:51 +0400 Andrew Wagin <avagin@gmail.com> wrote:

> >
> > Could you please re-test with these
> >
> >        http://marc.info/?l=linux-mm-commits&m=133962463616232
> >        http://marc.info/?l=linux-mm-commits&m=133962463616231
> >
> > patches applied?
> 
> Yes. They fixed the bug. Thanks.

OK, thanks.  I didn't actually have those queued for 3.5.  Do now. 
I'll get them into Linus next week.

