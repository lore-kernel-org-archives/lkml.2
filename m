Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab1EaP2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:28:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58373 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab1EaP2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eafOqDa15tfiE7wuRlnUcfl36ZsVg7CbADAvz+if7PWBDQ5YU1/XSjfldrGRAfkFeD
         cTvyPqaNfqYZlmNKwIWoVBDGBhXeLvqOB+Kx0A6D45jGcQm4le6a3/k7wmtEfR9QjCAk
         9jHTm9RdozKEVSN9w595nixgwqEPqbdaE75hI=
MIME-Version: 1.0
In-Reply-To: <da8dbb76f0cb3762227d8d0a99eaff21@localhost>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
 <20110518.152653.1486764697527722925.davem@davemloft.net> <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
 <20110518.155200.801089483916944725.davem@davemloft.net> <20110518202025.GC4175@nuttenaction>
 <BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com> <fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
 <BANLkTi=p1V1x+y=-cH-Q7bvueu_4_D1ywQ@mail.gmail.com> <BANLkTimqtjskX5q2ovTp_c05MdqBDOWsRg@mail.gmail.com>
 <da8dbb76f0cb3762227d8d0a99eaff21@localhost>
From: tsuna <tsunanet@gmail.com>
Date: Tue, 31 May 2011 08:28:18 -0700
Message-ID: <BANLkTikuW7VF8AUPFYHYzGe7mXp5H_emjA@mail.gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 8:25 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> Skip sysctl, it is deprecated.

Sorry I meant a knob such as /proc/sys/net/ipv4/tcp_initrto.

> The initRTO is the ideal candidate for a
> per route knob. And happily you will solve 2) with the per route thing too!

You still need a knob for the default system-wide value, don't you?

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
