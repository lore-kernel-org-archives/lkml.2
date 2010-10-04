Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0JDTVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:21:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0JDTVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iy9ZMTETEJbQ9GAGvHH9tkKY12i4fGMkh+4Y7TwRnO6l9GtQgOpJtf5o+AbtrBfNeE
         CuJLL/s4LkFZ3IPAUVu/bu1YZHUdliMXp4Np8hcHI0prmyiW58d37Afe4B/79Ujr1weL
         Jx3kdKCuyLObIXKTZKTR0D+w1w6vBxRR85EQk=
MIME-Version: 1.0
In-Reply-To: <20100930.115828.57462004.davem@davemloft.net>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	<1285838880-4977-4-git-send-email-namhyung@gmail.com>
	<20100930.115828.57462004.davem@davemloft.net>
Date: Mon, 4 Oct 2010 21:21:24 +0200
X-Google-Sender-Auth: YZ0nk2Mc33pqAGoVFoXRwpJbwzk
Message-ID: <AANLkTik1TKERMvPT=p7wQhqmgG6ucX08o3dDZUQMM5vF@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 03/24] ptrace: change signature of arch_ptrace()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: namhyung@gmail.com
Cc: akpm@linux-foundation.org, roland@redhat.com, oleg@redhat.com,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 20:58, David Miller <davem@davemloft.net> wrote:
> From: Namhyung Kim <namhyung@gmail.com>
> Date: Thu, 30 Sep 2010 18:27:38 +0900
>
>> Fix up the arguments to arch_ptrace() to take account of the fact that
>> @addr and @data are now unsigned long rather than long as of a preceding
>> patch in this series.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: linux-arch@vger.kernel.org
>> Acked-by: Roland McGrath <roland@redhat.com>
>> Acked-by: David Howells <dhowells@redhat.com>
>
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
