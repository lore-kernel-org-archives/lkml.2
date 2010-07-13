Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0GMSPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:15:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021Ab0GMSPe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <4C3CAAC6.501@redhat.com>
References: <20100701175144.GA2116@kroah.com>
	<20100701173218.125822294@clark.site>
	<20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
	<AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>
	<4C3CAAC6.501@redhat.com>
Date: Tue, 13 Jul 2010 11:15:09 -0700
Message-ID: <AANLkTik_hRn9acIuuRBJDWLuQVUh9qE-blvgFmUQvzlz@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:04 AM, Avi Kivity <avi@redhat.com> wrote:
>
> Well, current upstream uses "m":

Yes, I'd expect current 2.6.34 to also show the same problem.

> and works; I also failed to reproduce with 2.6.32.16.  So I expect some
> toolchain involvement.

And yes, I do believe it's likely a newer gcc that triggers it too,
otherwise we'd have seen more reports of it.

                  Linus
