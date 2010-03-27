Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab0C0FNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 01:13:07 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:63906 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0C0FNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 01:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=nXMYJH6vjKCH0TmLyaqOqKNjPC3+J7xjxCotC07j6Yl9PYHVm8bxRiTEX72rSKymtN
         0nOikJtJKAEpl33xOAtJB5hJCmmIxLJytpClGfiO74SK39VXi3GIqKaZKmPLYuRAwIPV
         6WCwmCHdVFusoicGr14g7CjGEIbNjVSxnAEB0=
MIME-Version: 1.0
In-Reply-To: <a84509bbf49c6a286c571d8b4f569b4e54aea913.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com> <a84509bbf49c6a286c571d8b4f569b4e54aea913.1269655208.git.joe@perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 27 Mar 2010 01:12:43 -0400
Message-ID: <8bd0f97a1003262212j2cfea67dh30588e31e8b2bc94@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 8/9] drivers/serial: Fix continuation 
	lines
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks fine to me, thanks
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
