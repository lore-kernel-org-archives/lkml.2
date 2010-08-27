Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0H0Qa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:30:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42789 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0H0Qay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OKU4UaoTJ6NUeED4t1jbavYSjwJpkElT+lhXM9AOogkg2beejNZcPpuwwctvWEftKE
         q03AWsz8TBLyojtuQybx9bQjWNSFSz1tUaxD4nrD1Cjx7aujWdsPSFvR4Efh7+XFXiip
         5Lys2XDCalh9T7DprNEe8Hg2NHRHm/UKD4rtw=
MIME-Version: 1.0
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 27 Aug 2010 12:30:31 -0400
Message-ID: <AANLkTimU5ys+mS-04KmfxSbdSHB=sAyWA43T4yHO_saX@mail.gmail.com>
Subject: Re: [RFC PATCH 00/43] ptrace cleanups
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 05:41, Namhyung Kim wrote:
> Although I couldn't test all archs, I hope it will not break anything.
> Exceptional case will be "03/43 ptrace: change signature of arch_ptrace()"
> commit since it changes prototype of arch_ptrace() in system header file.
> It *will* break your build if it is applied alone, please use it with
> your arch counterpart. The same goes vice versa, of course.

sounds like these changes should be squashed into one then
-mike
