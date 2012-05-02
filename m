Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2EBMjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:39:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2EBMjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:39:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH] Documentation: power: suspend-and-cpuhotplug.txt: Fix typo
Date: Wed, 2 May 2012 14:44:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
References: <1335911272-5907-1-git-send-email-marcos.souza.org@gmail.com> <4FA0C553.7010902@linux.vnet.ibm.com>
In-Reply-To: <4FA0C553.7010902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021444.16823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 02, 2012, Srivatsa S. Bhat wrote:
> On 05/02/2012 03:57 AM, Marcos Paulo de Souza wrote:
> 
> > sysfs was expected in this context.
> > 
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Rob Landley <rob@landley.net>
> > Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> > ---
> 
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks, applied to linux-pm/linux-next.

Marcos, please CC all PM-related patches to linux-pm@vger.kernel.org in
the future.

Thanks,
Rafael


> >  Documentation/power/suspend-and-cpuhotplug.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
> > index f28f9a6..e13dafc 100644
> > --- a/Documentation/power/suspend-and-cpuhotplug.txt
> > +++ b/Documentation/power/suspend-and-cpuhotplug.txt
> > @@ -29,7 +29,7 @@ More details follow:
> > 
> >                                    Write 'mem' to
> >                                  /sys/power/state
> > -                                    syfs file
> > +                                    sysfs file
> >                                          |
> >                                          v
> >                                 Acquire pm_mutex lock
> 
> 
> 
> 

