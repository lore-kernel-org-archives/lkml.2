Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1EWDE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 23:04:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42487 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1EWDE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 23:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=l9Wds/AU3UqljMbZckKT9CNngTrvFxyfvv/OErBj7eLDONRLB+h5YE5LybMYs19NVv
         vNL5lUjBmtyV4/a/cknzPoIMFinyQu4enoL68jAa+xizZIofsP7DudA7+8CFcgik2wvy
         qezRJSEbrHG6qRzxbts1VHHMEqJY9AQTAThNU=
Date: Sun, 22 May 2011 23:04:49 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@natty-nar
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
In-Reply-To: <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105222258590.3372@natty-nar>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar> <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com> <alpine.DEB.2.02.1105221817100.1868@natty-nar> <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 May 2011, Linus Torvalds wrote:

> On Sun, May 22, 2011 at 3:22 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >
> > Now I get a different call trace for the same NX error. (And Synaptics is
> > completely dead this time - not attributable to the patch, it was dumb
> > luck perhaps that it wored last time.)
> 
> Just because I'm crazy, can you double-check that you applied my patch
> and booted the right kernel?
> 
> 
As is of course the case - I am the crazy one here ;)

Grub switched the default boot order to old .39 vmlinuz and I should have 
noticed it but missed it - I blame it on Sunday.

Problem solved - no more NX exec error and who knows how Synaptics is 
working fine too - may be the exec after free scribbled something 
somewhere that hurt Synaptics.

Thanks,
Parag
