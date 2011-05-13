Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab1EMQyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:54:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759258Ab1EMQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:54:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: pm loss development
Date: Fri, 13 May 2011 18:54:57 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105122127.44484.rjw@sisk.pl> <BANLkTikZkRW6TWMcWyZC4_TdAWgjXDqvYA@mail.gmail.com>
In-Reply-To: <BANLkTikZkRW6TWMcWyZC4_TdAWgjXDqvYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105131854.57854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 13, 2011, Raffaele Recalcati wrote:
> Hi Rafael,
> 
> 2011/5/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> >> What happen normally in runtime pm implementation is that every devices
> >> are switched off and are enabled only when needed.
> >> In our case instead we have a completely functional embedded system and,
> >> when an asyncrhonous event appear, we have only some tens milliseconds
> >> before the actual power failure takes place.
> >> This patchset add a support in order to switch off not vital part of the system,
> >> in order to allow the board to survive longer.
> >> This allow the possibility to save important data.
> >
> > OK, so first, who decides what parts of the system are vital and what aren't?
> 
> Take a quick look at Documentation/power/loss.txt  paragrpah "2.4
> Power loss policies".
> You can decide what can be powered off.

I read the patches.  My question was about the general idea of who should
be responsible of making these decisions.

Thanks,
Rafael
