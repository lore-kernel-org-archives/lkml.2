Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0H3OFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:05:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58545 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0H3OFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=K25g/LHPGjdZTfzTkXu4YtwhMkVZvJ//Qixq+r4Rrwx1YnIxPj4qc/GQMcU64PwmRW
         ahBaIsV4QybrHzyyyhJ6q7/cBn3iW9wFrkprOWPoHjh2UTaQjXdseXpAvwSM+ZXvyWWZ
         hZQcZUkyob0a3Oiw08WLOS4TdV+WRAjepcI58=
MIME-Version: 1.0
In-Reply-To: <201008301402.23498.arnd@arndb.de>
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com> <201008301402.23498.arnd@arndb.de>
From: Namhyung Kim <namhyung@gmail.com>
Date: Mon, 30 Aug 2010 23:05:32 +0900
Message-ID: <AANLkTim8DxmJM+cbky8_Ojz05LQnEAi8fu55usDRK9Et@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/3] initramfs: cleanups
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 21:02, Arnd Bergmann <arnd@arndb.de> wrote:
> I think we can safely say that we do not want the config option, we should
> do one option or the other. Since Al already opposed implementing the calls
> using low-level VFS operations, that's probably not going to happen.
>

OK. Let's forget about it. :-)


-- 
Regards,
Namhyung Kim
