Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0GZUy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:54:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40923 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0GZUy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ZZJ4ZhlB/ukOqYI90DDcSBuoSaictaOFVPfyajmXnjrayoDVs2jr6y5Unj3Tw2ozKs
         xkA8u/vf4H2/+Lq62408FtsQ4XYwQccYvdDosRTERbDNkLbafeefDBjtIsv690g+lgkk
         jICjwcbB8AsUIIt5WICuQQrta8VjNGWltefU0=
MIME-Version: 1.0
In-Reply-To: <20100726204432.GC18853@merkur.ravnborg.org>
References: <20100726203814.GA18828@merkur.ravnborg.org> <20100726204432.GC18853@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 26 Jul 2010 16:54:05 -0400
Message-ID: <AANLkTimrZwE+_awxxoQtdkeS7OVY+jDMawyfkYUas58G@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 16:44, Sam Ravnborg wrote:
> From ce765a28adeb8878413a49ce62f442022d6a5b6a Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 26 Jul 2010 22:20:12 +0200
> Subject: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE
>
> Do not use LDFLAGS_MODULE in the top-level Makefile.
> So if user assign a value to LDFALGS_MODULE the
> original value is not lost.
>
> Use a kbuild internal variable that archs can use,
> and update all archs that used LDFALGS_MODULE.

assuming end behavior is the same, the Blackfin part is:
Acked-by: Mike Frysinger <vapier@gentoo.org>

also, could you say the same thing for CFLAGS_MODULE ?
-mike
