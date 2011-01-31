Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1AaVmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:42:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38437 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab1AaVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EmHCeYRXulmsB8AJiod1qTjQTuBpA0YypjM5pXBjIGHGnCB5E4KZApKwKNMCP1a2wt
         TrgXc7nNeWlW0KRtLE5xylrizmCyCb56d728bBCbQ6axDRRHtJ08jUjmQO4mpiGhIoQ/
         cvhpP2YKSIJosxV8ZQ8XQp59/aijQpfHErakY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimgTCdJfyKcyrpM-VgWtNCFonu2rvca+pkc+ebh@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
	<AANLkTimgTCdJfyKcyrpM-VgWtNCFonu2rvca+pkc+ebh@mail.gmail.com>
Date: Mon, 31 Jan 2011 21:42:47 +0000
Message-ID: <AANLkTi==JWuwP23xCHgMXZefVAw_kPzQmh1nRqcot0eM@mail.gmail.com>
Subject: Re: typecheck code
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Dave Hylands <dhylands@gmail.com>
Cc: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>If dummy and dummy2 are of different types, then when you try and do a
>pointer comparison (&dummy == &dummy2) it will produce a compiler
>warning/error.

O--ooohhh...
I came across this ages ago when I was trying to unravel the jiffies
wraparound macros and I've been scratching my head ever since trying
to figure out what this line _really_  did. A bit arcane, isn't it?
Thanks a lot Dave and everyone for explaining.

Cheers
Julie
