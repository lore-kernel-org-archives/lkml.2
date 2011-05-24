Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab1EXVtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:49:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58706 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1EXVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FOqeGxtGo0HyzgB6PLKa/R0LRep7aZrl2XcpJfxfJejcOzZG6I3u7kvrbihEyak6dc
         1z759/vab53e1v8Y9WIIcJvtq5gApeuKoQdZanDLe+7NSg1a2nOm9rO+oQVoFjKzq2cA
         XuDmKI2ttAfLh4NGsgk15GiP7MMdiYuhkl4dg=
MIME-Version: 1.0
In-Reply-To: <1306270010.7501.43.camel@hiromu-MacBook>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	<BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
	<1306242400.7501.10.camel@hiromu-MacBook>
	<4DDBB150.2090602@suse.cz>
	<1306247192.7501.25.camel@hiromu-MacBook>
	<4DDBC846.8050402@suse.cz>
	<BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
	<1306258716.7501.35.camel@hiromu-MacBook>
	<BANLkTikFT17GOgV1UJTFxEG+P2X-u4ZJjw@mail.gmail.com>
	<1306270010.7501.43.camel@hiromu-MacBook>
Date: Tue, 24 May 2011 17:49:08 -0400
Message-ID: <BANLkTi=zVAMzbx7tXP2tOfBGE_hcMFzxOg@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Arnaud Lacombe <lacombar@gmail.com>
To: Hiromu Yakura <hiromu1996@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 24, 2011 at 4:46 PM, Hiromu Yakura <hiromu1996@gmail.com> wrote:
> [...]
> conf_write() is called after the configure changed.
> So I don't think we should handle the failed case of conf_write()
> because the purpose of this patch is not to losing changes.
>
Then your patch is incomplete. only open(2) and write(2) can fail in
more than 30 different ways, you check 1.

 - Arnaud

ps: I am not even addressing the race-condition introduced by your patch...
