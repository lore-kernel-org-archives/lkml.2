Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JWMWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:22:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:16469 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2JWMWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:22:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344211200"; 
   d="scan'208";a="15333349"
Date: Tue, 23 Oct 2012 13:22:20 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
In-Reply-To: <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210231320390.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-10-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com> <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
 <alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com> <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 6:19 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> 
> >> > The series is starting to get in good shape!
> >> > I tested it on a 2G and an 8G VM and it seems to be working fine.
> >>
> >> domU on 32bit and 64bit?
> > domU 64bit
> 
> Can you test domU 32bit too?
> I did not test that, and looks like Jacob only test 64 bit domU too.

Sure. It works fine.
