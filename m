Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0E0NPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:15:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38145 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0E0NPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mJe0vGo/jDRrtP4y2BvwfPcya74pddlk+dLNchLeP3Qy+Gji+KUrd8c+D+tadzqKHw
         L7JvlEFnF9UpwXZ+F/YaDZxz5eh5Ex97KnqSFL4fSETwiQcoy5IZWve1BeEF2/ETL/Ue
         JvytRQ5R7r387mXbgKkmkuwcKjfF22ny4lLPo=
MIME-Version: 1.0
In-Reply-To: <20100527115716.76ce299a@linux.intel.com>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 
	<20100526151152.28deaa6c@linux.intel.com> <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com> 
	<20100527115716.76ce299a@linux.intel.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 27 May 2010 21:15:12 +0800
Message-ID: <AANLkTikopvVRz063swM70j2l3Jig5ePJHdICO9CcDDrc@mail.gmail.com>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
To: Alan Cox <alan@linux.intel.com>
Cc: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

> It is a lot more. Things like arabic vowel handling for example, or
> mixed direction text.
> Pango does the job. Pango is the wheel.
I may haven't represent my idea clearly. No one wishes that fbcon can
do as good as pango. The important thing is, question marks have no
information, but scripts which may have placement issues have as
much information as the one rendered by pango.

> Kernel code is unpageable, privileged and unable to doing things
> trivially like dynamic font management. It's the wrong place for this
> kind of stuff because doing fonts right and especially doing language
> rendering right is *hard*.
Umm... maybe use bitblit instead of render is better? The current
mainline kernel already has features of font replacing, utf-8 decoding,
and "wide" char identification. Plenty of utf-8 bitmap fonts disperse on
the world, they just have more than 512 glyphs so vt cannot handle them,
Trust me, It's nothing more than provide a larger storage.

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
