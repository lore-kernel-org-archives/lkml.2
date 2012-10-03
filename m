Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2JCWRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:17:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40572 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2JCWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAKi4VAJgRr0JkuCbMW1vEgEbr5OUiJ-zHTHtAWTbOYFcsfFodg@mail.gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
 <CAKi4VAJgRr0JkuCbMW1vEgEbr5OUiJ-zHTHtAWTbOYFcsfFodg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 15:17:15 -0700
X-Google-Sender-Auth: pucAwwX3NjJq2p_tdFdVtMwLvR8
Message-ID: <CA+55aFw9-8cfcGrnLhjDn_zoq44TbSByPkqxkPquUsk=x+Ez9g@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 2:58 PM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
>
> So maintaining the fallback or adding a configurable entry to set the
> firmware paths might be good.

Yeah, I do think we need to make it configurable. Probably both at
kernel compile time and dynamically.

The aim of having a user-mode daemon do this was that it would be easy
to configure. Sadly, if we can't trust the daemon, that is all totally
worthless.

               Linus
