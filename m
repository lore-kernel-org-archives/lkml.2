Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0KPVa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:30:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759152Ab0KPVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <1289929012.11405.12.camel@mulgrave.site>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
 <20101113051635.GA11613@havoc.gtf.org> <20101116071029.GA13540@havoc.gtf.org>
 <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com> <1289929012.11405.12.camel@mulgrave.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 13:30:35 -0800
Message-ID: <AANLkTinBZ9dEHVB9zc89RuBc-d3S2TSn9UAQT7zJbdeQ@mail.gmail.com>
Subject: Re: [PATCH v5] SCSI host lock push-down
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 9:36 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> I was thinking through next for a few days to see if anything breaks in
> the architectures with scsi drivers we can't compile on x86 ... but
> realistically that will happen in -rcX as well, so I'm happy either way.

I really just wanted a firm "just take the patch" or "wait for a
pull", so that I can forget about this issue either way.

But it sounds like I have an ack for you, so I might as well just take
the patch.

                     Linus
