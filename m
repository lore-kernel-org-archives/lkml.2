Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0E0NyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:54:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40456 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0E0NyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nDbvNvcAcqsFo6NZBULcLYJlJMbhxLFn5z2hyY5HGrf8qWKfRqzX2gtGf1IRmHEdVy
         AyhJd16T60JKNPrB6JiCYL7TBA66mzIIAkvPXZ/yIjeHMlDGcLhL1J6ro8DTy3aXqT65
         qyji5Uz4XNYfPZ1+WNdJ3VKo9IylIY+8MYTuc=
MIME-Version: 1.0
In-Reply-To: <20100527134120.GA44150@dspnet.fr>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 
	<20100526151152.28deaa6c@linux.intel.com> <20100527134120.GA44150@dspnet.fr>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 27 May 2010 21:46:11 +0800
Message-ID: <AANLkTil790wLxA-phu_pevzXXx1m8U4sILq7rYFGE2FM@mail.gmail.com>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Cox <alan@linux.intel.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

> The Unicode book should be required reading for anyone who starts
> talking about displaying utf-8/unicode text.  It's a *very*
> interesting book with way more than code charts in it[1].
You mean "The Unicode Standard, Version 5.0"?
Oh such a hugh brick. :) What's it about? History?
I'll read it tomorrow in the library.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
