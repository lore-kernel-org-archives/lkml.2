Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1DLMvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:51:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43064 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1DLMvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TK5IrwSubD/kErNWMA+5xwi6PJEWAEHEfcsxauRcq35dRPkQosaRnXI1gk1FeOi2PZ
         SWzGOZN5dst0kZDV3oPiOF1PMR1odAczluTB8QynzLgyJJ1LSr+jRImyO9EL+6WtYYyS
         FedG9vdg7GAgr0k9ZX3XOpSA7wXFSU1kZsrNs=
MIME-Version: 1.0
In-Reply-To: <BANLkTimAY2YTFE1_uFJg=XVtV_ww2jdJrw@mail.gmail.com>
References: <BANLkTimAY2YTFE1_uFJg=XVtV_ww2jdJrw@mail.gmail.com>
Date: Tue, 12 Apr 2011 15:51:41 +0300
X-Google-Sender-Auth: 4nb_aPiIOBBHgCTnxb8v6kXepEg
Message-ID: <BANLkTimAvqT0MxPWvQH6ga698TYhCXF3CQ@mail.gmail.com>
Subject: Re: regression - slow git rebase performance with 2.6.39-rcX kernel
From: Pekka Enberg <penberg@kernel.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Fixed your empty CC list. ]

On Tue, Apr 12, 2011 at 3:45 PM, Zdenek Kabelac
<zdenek.kabelac@gmail.com> wrote:
> I'm noticing quite slower speed of my git rebase commands on my git
> tree compared with 2.6.38 kernel.
> I've  T61 with SSD disc drive, ext4 fs, and by default deadline disk
> io scheduler
> The counter showing the number of 'rebased' patches on top of master
> is going much slower.
> When I boot 2.6.38 kernel it's much faster.
>
> Is it a known problem - or do I need to make a bisect ?

No, I don't think it's a known problem. Git bisect would be helpful, obviously.

                        Pekka
