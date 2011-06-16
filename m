Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1FPMy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1FPMyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:54:54 -0400
Date: Thu, 16 Jun 2011 14:52:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616125256.GB19312@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615190302.GA16440@redhat.com> <1308223158.8230.66.camel@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308223158.8230.66.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Greg Kurz wrote:
>
> On Wed, 2011-06-15 at 21:03 +0200, Oleg Nesterov wrote:
> > Forgot to ask,
> >
> > On 06/15, Greg Kurz wrote:
> > >
> > > The need arises in the LXC community when one wants to send a signal from
> > > the host (aka. init_pid_ns context) to a container process for which one
> > > only knows the pid inside the container.
> >
> > I am just curious, why do you need this?
> >
>
> Because some LXC users run partially isolated containers (AKA.
> application containers started with the lxc-execute command). Some of
> the user code runs outside the container and some inside. Since
> lxc-execute uses CLONE_NEWPID, it's difficult for the external code to
> relate a pid generated inside the container with a task. There are
> regular requests on lxc-users@ about this.

Well, this doesn't answer my question ;) Why do you need to send the
signal into the sub-namespace, and how/why do you know the pid inside
the container.

OK, nevermind, I was just curious.

Oleg.

