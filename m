Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0EKTPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:15:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34050 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0EKTPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=na0hC+nl0vXH3TnwbSAg7e9InkgF2BKeorqeDh/mKa0LESu3Vp7OOBDaE0lhcj77Lp
         9+JBb6VppKpwtovA0sfFUbiLCrMx9bttuXf8EH7N+6Z6ZsPDcRmJXeY0YOUTvRx3+pSp
         p+oR1AYFfAdAPQTntw/YV+1Zz8ltY7JDE++y8=
MIME-Version: 1.0
In-Reply-To: <20100511150730.GD14895@suse.de>
References: <20100510223322.347254355@kvm.kroah.org>
	 <4BE896FC.2050407@tuxonice.net>
	 <AANLkTinUQ-ra-0lknwTAPIp996NU40o0LKjsq1sXc6Va@mail.gmail.com>
	 <20100511150730.GD14895@suse.de>
Date: Tue, 11 May 2010 21:15:10 +0200
Message-ID: <AANLkTim6VIWZzvRfzJkbKfVKNispi0hiNm_gy8L0OutT@mail.gmail.com>
Subject: Re: [057/117] ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio 
	1558
From: Daniel Chen <seven.steps@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Daniel T Chen <crimsun@ubuntu.com>,
       Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 5:07 PM, Greg KH <gregkh@suse.de> wrote:
> As this mirrors what is in Linus's tree, I say we just leave it alone,
> is that ok?

That, too, is fine. The quirk is correct in the source code.

-Dan
