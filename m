Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0KPOro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:47:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36044 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab0KPOrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:47:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YqOfFNzOLf/jt96/5tfvKLhUDTLAB0dX/wqXEYpt6JsUYqaPH9bZXO61kf9BfRzePf
         R7oGs2RqHbeO1Yw1fVUTxNTMZkXXz1ybc0vZiv8qe02U3dhyzZL6rQLsRc9mroMpaT90
         oQnt9AQbWOHLCblVp/AeipEj7d3AooYx6yj0c=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k/NazW/cWiOQZMEhfr0GaD7hightlxrCr5So8dVKJs5HO78SWJZVPxPFx+GAFsoxL4
         A7jB+xKb/V2zZ+V/9OMXwfwkW3kB3nXpD2ze+gwWjothubP8a78e/oMP3vW4SgyfJ0r+
         uH+Z0NXcmWRFfZynI+iwv09dL+X+2igTaCqbU=
MIME-Version: 1.0
In-Reply-To: <1289916683.2109.625.camel@laptop>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	<1289778189.5154.10.camel@maggy.simson.net>
	<AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	<AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	<1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116015648.GA11534@redhat.com>
	<1289916171.5169.117.camel@maggy.simson.net>
	<1289916683.2109.625.camel@laptop>
Date: Tue, 16 Nov 2010 15:47:38 +0100
Message-ID: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 3:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2010-11-16 at 07:02 -0700, Mike Galbraith wrote:
>> While you can identify firefox etc,
>> it's not being done, and requires identifying every application.  Heck,
>> cgroups is built in, but userspace doesn't even mount.  Nothing but
>> nothing uses cgroups.
>
> The yet another init rewrite called systemd is supposedly cgroup happy..
> No idea if its going to be useful though, I doubt its going to have an
> effect on me launching a konsole or the like, or screen creating a bunch
> of ttys.

systemd uses cgroups only for process tracking. No resource
management. Though afaik, Lennart has some plans of doing resource
management using systemd. I wonder how autogroups will interact with
systemd in that case.

Dhaval
