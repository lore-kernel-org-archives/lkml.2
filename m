Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1FMScm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:32:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33005 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1FMSci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JYe3/VBGCrUHjsOFefhzYoVBHQ+0pRw4XeHjF0jOQHzMfK1gHSoxknJAB7sURCZder
         KBuTJrEjRxvwH/DuzBK2dIJwnL632jG0mvK5wOa7SFizQfJ8MZYvd0hc9wzfw7oYSYjP
         XeZd32jeV5Ef6ylTPzHmsq+0ivghj40ScfH5k=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=iuSZtp=dJv-f8rvBeNMqQD8EcTQ@mail.gmail.com>
References: <1307989217-22004-1-git-send-email-geert@linux-m68k.org>
	<BANLkTi=iuSZtp=dJv-f8rvBeNMqQD8EcTQ@mail.gmail.com>
Date: Mon, 13 Jun 2011 20:32:36 +0200
X-Google-Sender-Auth: TXpD3X_z8CU4aAs6WnmT6tnDFU8
Message-ID: <BANLkTi=AO5E0Vu-tEaHCimLXJ+mmaazfEw@mail.gmail.com>
Subject: Re: [PATCH] scsi/trivial: Spelling hsot -> host
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Mon, Jun 13, 2011 at 20:24, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jun 13, 2011 at 8:20 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Where is the reference to http://marc.info/?l=linux-scsi&m=130788046617817&w=2 ?

Sorry, I did check my lkml mailbox whether a similar patch was sent
recently, but didn't find any.
And I'm not subscribed to linux-scsi.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
