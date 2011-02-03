Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1BCA7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:59:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1BCA7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:59:24 -0500
Message-ID: <4D49FDA2.9020900@zytor.com>
Date: Wed, 02 Feb 2011 16:58:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org> <4D49B5F6.5010606@zytor.com> <4D49B903.2080602@goop.org> <20110203005517.GA30220@khazad-dum.debian.net>
In-Reply-To: <20110203005517.GA30220@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 04:55 PM, Henrique de Moraes Holschuh wrote:
> 
> But I'd really, really appreciate if someone from Intel [that actually cares
> for operating system support of microcode updates] could vouch that we're
> allowed to do that (convert their text packs to binary packs, merge
> microcodes from older packs with the new to have a single pack with all
> microcodes in their most up-to-date revision, and distribute the resulting
> binary packs) before I make the tool public.
> 

I'm trying to figure this stuff out already.

The actual conversion isn't a problem, obviously.

	-hpa
