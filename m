Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0IMKHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:07:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50269 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IMKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=hD85s1inyfmAHAk5qgVa/aotw+XnivEXvwgyXLDsPLnBvA4hPZzoBjWAiH3+jpLPvA
         xWX4m7nwa9XuGHQl5i83/BLUrRinbBiJAwa1Lu1WyaNs8GqqbdwzTqSnNpNgecPwMbFm
         F8nk013Stx8HMLkVuYf6AASpSpSbDH2bcB6LQ=
MIME-Version: 1.0
In-Reply-To: <4C8DCF72.4050701@monstr.eu>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
 <1283442391-23612-15-git-send-email-namhyung@gmail.com> <4C8DCF72.4050701@monstr.eu>
From: Namhyung Kim <namhyung@gmail.com>
Date: Mon, 13 Sep 2010 19:07:13 +0900
Message-ID: <AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
To: monstr@monstr.eu
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 16:14, Michal Simek <monstr@monstr.eu> wrote:
> Hi,
>
> just for my info how does it look like this patch series?
> I mean who should added that patches to mainline?
>

Hello,

I am not sure but I hope Roland will take care of it.

-- 
Regards,
Namhyung Kim
