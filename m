Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2BEKz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:55:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BEKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:55:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
Date: Sun, 5 Feb 2012 11:59:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <201202042327.10045.rjw@sisk.pl> <CAJd=RBDz6bm-2p28506+0CuC3P6kED8kXLrZe_TPuhTQSUo67w@mail.gmail.com>
In-Reply-To: <CAJd=RBDz6bm-2p28506+0CuC3P6kED8kXLrZe_TPuhTQSUo67w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202051159.38870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 05, 2012, Hillf Danton wrote:
> On Sun, Feb 5, 2012 at 6:27 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, February 04, 2012, Srivatsa S. Bhat wrote:
> >> On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:
> >> Hi Rafael,
> >>
> >> I have reworked the changelog of this patch to indicate that this fixes a
> >> regression. Here is the updated patch:
> >
> > Well, I've already fixed that up in my tree, but thanks anyway. :-)
> >
> 
> Nicer if gurus open wider windows for patches received, no?

Well, I hope Srivatsa didn't mind. :-)

Thanks,
Rafael
