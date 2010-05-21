Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0EUIzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:55:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60278 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0EUIzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g73J+bJDpRzii2+AzWVMwL/et+DpEstyxSt91RGMdsaVgZAWIQbGdU8KbM5A1cyq2Q
         Sq8GVZEkJf2Uhgs/jtTsXS/0trgF79zbT8LMHkl+PMN7Q95HaNRI1yOPAJvmiY128rrG
         q0uDafK0irYdIRbrCTcqSUGN1ogdIYs0FhD7s=
MIME-Version: 1.0
In-Reply-To: <20100521084932.GP3972@infomag.iguana.be>
References: <1268150860-28011-1-git-send-email-vapier@gentoo.org> 
	<1274430208-15087-1-git-send-email-vapier@gentoo.org> <20100521084932.GP3972@infomag.iguana.be>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 21 May 2010 04:55:30 -0400
Message-ID: <AANLkTilI5L6c3MeZ_epPsYZEEcaM816JntyJNWFTIz5L@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] [WATCHDOG] bfin: use new common 
	Blackfin watchdog header
To: Wim Van Sebroeck <wim@iguana.be>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:49, Wim Van Sebroeck wrote:
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> Andrew: could you pick this up ?  it was posted a few months ago ...
>
> This is allready in the linux-2.6-watchdog tree. I'm reviewing a last driver
> and will then sent a pull request to Linus.

thanks
-mike
