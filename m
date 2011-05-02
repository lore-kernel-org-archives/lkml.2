Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1EBSpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:45:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64786 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab1EBSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lc9ONgnuhFSFLoL8dtQl0TJBwmHbMNCMsqvolhWmCSs4RHuljE3UH33IznQHB/wyvw
         RB8EG6RalcXooeElV840Hf1SfhsUxKlJBStAA8xC4UWyGvSHTHwLU2YYk3WszJIzvLKv
         OzTPHvgcrHr4TcVAeSrP4uPyV7l8zAPGWgY6I=
MIME-Version: 1.0
In-Reply-To: <2b5d75ba05bd7889ac80514015e36ad2.squirrel@www.skyhub.de>
References: <71633.1304013549@localhost>
	<1304083893-18849-1-git-send-email-mmarek@suse.cz>
	<BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
	<20110502170736.GB18740@merkur.ravnborg.org>
	<BANLkTi==Tx6sXcA2Bk6Cp7wc1DY-7c1V3g@mail.gmail.com>
	<2b5d75ba05bd7889ac80514015e36ad2.squirrel@www.skyhub.de>
Date: Mon, 2 May 2011 14:45:00 -0400
Message-ID: <BANLkTikQ6b8BMYXZcFzmavx-geqzqVvrvA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: Arnaud Lacombe <lacombar@gmail.com>
To: boris@alien8.de
Cc: Sam Ravnborg <sam@ravnborg.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Michal Marek <mmarek@suse.cz>, valdis.kletnieks@vt.edu, bp@alien8.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 2, 2011 at 2:03 PM,  <boris@alien8.de> wrote:
> This is exactly why we're trying to get a feeling of this by _running_
> it and _then_ _bitching_ about it.
>
This is just what I did, might you consider it bullshit or not. I
really do _dislike_ Michal's interface. I proposed a solution, Americo
did too. I guess that unless a patch is submitted, this will go
nowhere.

> And this is for DEVELOPERS only - if
> they've introduced it in their scripts, then they should be able to fix
> any changes very easily.
This argument is worthless. As soon as it gets in mainline, everybody
will be free to use it, newbs, QA, packager, ...

 - Arnaud
