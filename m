Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0HaHgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:36:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57068 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0HaHgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GZkeTKnMdFi3LVVYG9GgrpUIZFd/PWhMxgMGRQnd+k8zmWbG9eKwRDDl2f7ZMDSJhO
         tLNdX+IKKXl7QEb8mqjsfKR3KIvpECxqwFPYg6GmFxiCw7Cih16JYW9OsgY5951K+1Uf
         rvn6vyPN5CMbUK0qqQN0043qdMek3Gmj9dgok=
MIME-Version: 1.0
In-Reply-To: <26799.1283201411@redhat.com>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
	<20100827020038.27277.27239.stgit@warthog.procyon.org.uk>
	<4C7B59E1.6010904@snapgear.com>
	<26799.1283201411@redhat.com>
Date: Tue, 31 Aug 2010 09:36:16 +0200
X-Google-Sender-Auth: wgyquYffa-_Z3WpOwYLSKxkVyCc
Message-ID: <AANLkTikJ5pio3WYmZFAyWpD32hssZoDxX7XSTXN_qV09@mail.gmail.com>
Subject: Re: [PATCH 18/22] Fix M68K irqflags
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 22:50, David Howells <dhowells@redhat.com> wrote:
> Greg Ungerer <gerg@snapgear.com> wrote:
>
>> I have no problem with the changes as such. But I would rather
>> not have separate mm and no headers if we can avoid it.
>
> Well, I can roll the headers into one, but then it'll be much more #ifdef'd if
> you're okay with that.  The IRQ handling seems sufficiently different to
> warrant that.

Indeed, m68k doesn't use generic hardirqs yet, m68knommu does.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
