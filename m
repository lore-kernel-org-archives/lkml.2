Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0K1KDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 05:03:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52480 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0K1KDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 05:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qTAoANvTG0UxBx1xy0ewqPnUDYMiA8RaSUw6NRzmK+qm/oL5b9wkB06UejGqFOjVJd
         tHQEytHYslNghUIUK76drV2QWfmKxiwW/ijfXUX0YlryywxObmpWdeRa/M3Q8VCpZYxt
         dFtqfuzzArOHNsQQ6D/E95aTZb0G0y1lMjz4w=
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linuxconsole-dev@lists.sourceforge.net, linuxconsole@vger.kernel.org
In-Reply-To: <20101128081528.GA20705@suse.cz>
References: <1290750825.2372.59.camel@cai.gentoo>
	 <20101127125742.GD4865@const.famille.thibault.fr>
	 <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com>
	 <20101128081528.GA20705@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Sun, 28 Nov 2010 16:29:41 +0800
Message-ID: <1290932981.710.2.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 09:15 +0100，Vojtech Pavlik写道：
> 
> Well, on VGA you could use the 512 glyphs available (9 bit character, 7
> bit attribute) and dynamically change the font in the video memory to
> always contain the characters that you need on the screen. Chances are
> that you won't need all 512 at any single time. The screen isn't that
> large in classic VGA mode.
> 
> But since VGA is mostly dead these days anyway, it'd be a neat hack, but
> probably not worth the effort.

Can't do that. That's too tricky, and some times we *DO* need more than
512 different glyphs.



