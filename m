Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab1EMUTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab1EMUTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:19:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Leun <lkml20100708@newton.leun.net>
Subject: Re: AHCI driver problem on ICH (Re: AHCI driver problem on SB700/SB800 w/ Acer Ferrari One)
Date: Fri, 13 May 2011 22:20:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com> <20110513215413.3480d6b5@xenia.leun.net>
In-Reply-To: <20110513215413.3480d6b5@xenia.leun.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105132220.08760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 13, 2011, Michael Leun wrote:
> On Fri, 13 May 2011 19:39:51 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Can you guys please take a look at bug#34692?  It seems to be the
> > same problem.
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=34692
> > 
> > The offending commit seems to be 270dac35c2.  Does reverting it
> > resolves the problem for you guys too?
> 
> - Does not happen with 2.6.38.6
> 
> - Happens 100% of cases with 2.6.39-rc7 (connect ac adapter or suspend
>   to ram with ac connected and resume with ac disconnected)
> 
> - Reverting 270dac35c26433d06a89150c51e75ca0181ca7e4 fixes issue

I can confirm that.

Thanks,
Rafael
