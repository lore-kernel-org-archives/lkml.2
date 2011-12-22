Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1LVLJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:09:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52918 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1LVLJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:09:04 -0500
MIME-Version: 1.0
In-Reply-To: <1324525237.5916.114.camel@gandalf.stny.rr.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
From: Raz <raziebe@gmail.com>
Date: Thu, 22 Dec 2011 13:08:40 +0200
Message-ID: <CAPB=Z-rrMLyFAJXUBC+BCqegr2bNB4on0gNaTWY-ddMWsMGJpA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey steven

what is the relation between 3.2 rt patches and 3.0 rt patches ? back
portability or anything else ?

On Thu, Dec 22, 2011 at 5:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Dear RT Folks,
>
> I'm pleased to announce the 3.0.14-rt31 stable release.
>
>
> This release is just an update to the new stable 3.0.14 version
> and no RT specific changes have been made.
>
>
> You can get this release via the git tree at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
>
>  Head SHA1: 6aaac97b2b5e0750a2739c3a247d79d4fadac43e
>
>
> Or to build 3.0.14-rt31 directly, the following patches should be applied:
>
>  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz
>
>  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.14.xz
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.14-rt31.patch.xz
>
>
> The broken out patches are available at:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.14-rt31.tar.xz
>
> Enjoy,
>
> -- Steve
>
>
