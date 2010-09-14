Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0INCjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:39:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43501 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0INCjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IFCynpd7BoD7nw4xB1PhjIzKczvL9Z09EESMaDp+CgtgdOyE9KJUunJsmfZKc5RMkq
         XUSDGN+SbzH/E7CmFh9EMiLV11erIEJEVConKwnM/FXd0cfzJ8kLWhe7/mY4lXF/FEM2
         h3q1cIZnNr9Bh1asZan4DgoHgCstk/d9RrRto=
MIME-Version: 1.0
In-Reply-To: <20100914023129.8ACE9403E6@magilla.sf.frob.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
 <1283442391-23612-15-git-send-email-namhyung@gmail.com> <4C8DCF72.4050701@monstr.eu>
 <AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
 <20100914021532.9C53E403E6@magilla.sf.frob.com> <AANLkTikWqmxob31RjTxu3zwypxJ29KO=zVEko-157iLB@mail.gmail.com>
 <20100914023129.8ACE9403E6@magilla.sf.frob.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 14 Sep 2010 11:39:24 +0900
Message-ID: <AANLkTinceMB0YKcaCBSo9qnt2uZngf3gbuDzB4tPDCMc@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
To: Roland McGrath <roland@redhat.com>
Cc: monstr@monstr.eu, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 11:31, Roland McGrath <roland@redhat.com> wrote:
> The cosmetic-only version of the generic patches was fine with me,
> i.e. where you don't replace put_user with copy_to_user et al.
> I don't have a particular say on the various arch code (a few of the arch
> maintainers tend to listen to me about this stuff, but it's up to them), so
> I didn't respond to those.
>

OK. That means I can add your Acked-by's on architecture independent
part in this series
which are 01, 03 and (resended) 02, right?

-- 
Regards,
Namhyung Kim
