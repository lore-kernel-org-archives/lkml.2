Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0ELRm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0ELRmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JKgCIR0E0vQviVvQ5LdcYCszmAZmH74WdfuU+eeYxiQVGJFSvm49WIPpqvJAotqUOe
         owJZQpu3rUOOF2nw6aOJyCCgegKvI0Y672pcmP51nZBmZXtOQdu9IY6XDOk7uTJ0Mbo5
         IgBiAVawnZ7t6GKGH4JfZS0DOjbES7dOqyO+0=
MIME-Version: 1.0
In-Reply-To: <4BEAE7A1.2010001@intcomgrp.com>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop> <4BEABDF8.40206@redhat.com>
	 <4BEAE7A1.2010001@intcomgrp.com>
Date: Wed, 12 May 2010 19:42:20 +0200
Message-ID: <AANLkTikEyJ8q9GkpyZo0OUY4MLM_soWEviiBG2R6H-mY@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: James Kosin <jkosin@intcomgrp.com>
Cc: Jan Safranek <jsafrane@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, lennart@poettering.net, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 7:38 PM, James Kosin <jkosin@intcomgrp.com> wrote:
> On 5/12/2010 10:40 AM, Jan Safranek wrote:
>
> On 05/12/2010 04:20 PM, Peter Zijlstra wrote:
>
> On Wed, 2010-05-12 at 16:13 +0200, Dhaval Giani wrote:
>
> What you are saying is that an application
> programmer who wants to just use memory cgroups should also care about
> cpusets and just about countless other cgroup subsystems that can
> exist.
>
> That's exactly what he says if he mounts them together.
>
> No, the programmer does not mount anything. Programmer writes application
> which wants to create a subgroup. System admin is the one who decides what
> is mounted how. And the programmer (=me) needs a way how to reliably create
> a subgroup, without knowing details about all controllers. E.g. 'blkio'
> controller is quite new one, old applications do now know anything about it,
> yet according to your idea, the application *must* provide sane defaults to
> it.
>
> Jan
>
>
> Jan,
>
> I think sane defaults should be enforced only if the application actively
> uses the device.  Your right in that you don't want to have to guess as to
> which devices are mounted as long as you don't touch the devices that aren't
> mounted everything should be okay and work for the specific device or mount
> you are working with  (which by the way you need to know!!!)....
>

I seem to get the impression that there is a miscommunication here. We
are talking about the cgroups feature here (more details are available
at http://www.mjmwired.net/kernel/Documentation/cgroups.txt ). We
really are not talking about devices, but about specific cgroup
subsystems which can be mounted together, and are not under the
control of the programmer.

> PS: Providing a set of defaults on creation may lead to a security
> problem... just an afterthought.
>

Which is why you have *sane* defaults.

Dhaval
