Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0DUFIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:08:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab0DUFIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:08:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Bug #15730] Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
Date: Wed, 21 Apr 2010 07:09:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.K_G.dRSzLB@tosh> <20100420052740.GA20482@liondog.tnic>
In-Reply-To: <20100420052740.GA20482@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210709.30228.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Borislav Petkov wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Tue, Apr 20, 2010 at 05:19:23AM +0200
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15730
> > Subject		: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
> > Submitter	: Borislav Petkov <bp@alien8.de>
> > Date		: 2010-04-02 17:59 (18 days old)
> > Message-ID	: <20100402175937.GA19690@liondog.tnic>
> > References	: http://marc.info/?l=linux-kernel&m=127023173329741&w=2
> 
> Fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6.

Yup, closed.

Rafael
