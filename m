Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0J0GzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:55:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57341 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0J0GzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vx+5O4yt4/7uEziDh9bLLfZOjuOiNhs2v9N0Pii5v709TPKFtcGmuCt3ChUY76QGvy
         jBJialsKBhprf9JslS6triG/TzvnoBNGNfNHUXqISMa61MdkKD4kYdM9iNjv2ubS5aKN
         VpmZHH40qgGqhcnnTwHOKzwVuaVTrVp7TlGgQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010261818300.3115@localhost6.localdomain6>
References: <4CC3F13B.4030107@gmail.com>
	<alpine.LFD.2.00.1010261818300.3115@localhost6.localdomain6>
Date: Wed, 27 Oct 2010 08:55:19 +0200
Message-ID: <AANLkTikyunbd2ACuS0mzR7NV0sfWFRdGRaxna9ZPM-Nt@mail.gmail.com>
Subject: Re: [PATCH] archs: add ioremap_change_write_prot
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/26 Thomas Gleixner <tglx@linutronix.de>:
>
> Why inventing a new interface if we have one already ?
>
>    set_memory_* which has a few more variants than ro/rw
>
> Also this is not related to ioremap, these are functions which works on
> almost anything when there are other restrictions in place.
>
> So implementing set_memory_ro(), set_memory_rw() for those archs which
> you need it for makes more sense than creating a misnomed and
> misplaced wrapper.
>
> Thanks,
>
>        tglx
>

Andi and Thomas, thanks for your response. I was trying to use an
homogeneous interface, I see that only x86 has got set_memory_*, but
ok I can use these ones. About the name I used, I was trying to use a
way to change the protection after an ioremap, so for x86 means a call
to these functions, but other archs could mean other checks.

However it needs to adds a define or something similar to know if the
archs implements or not this interface. Suggestions about this point?

Thanks.

Marco
