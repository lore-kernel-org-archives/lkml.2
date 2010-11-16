Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0KPV0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:26:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0KPV0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pjvfnmEIjpVZ2MWLH0AypUvHX7iYq2IGrhzphKX9Xha18B6yHkgXR6Qow4hnxskFvn
         G6BkSxKw9H8DzCkRti7KrLmwBPiCxph62n1xHh50dmGC+4oB3AVe1+c//72IUg4S5k1V
         6JmP139Rp5bIo/V4DrIc6bFlKq4xbRvFvCpS0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
References: <1289606118.3015.539.camel@mulgrave.site>
	<AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
	<20101113051635.GA11613@havoc.gtf.org>
	<20101116071029.GA13540@havoc.gtf.org>
	<AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
Date: Tue, 16 Nov 2010 16:26:03 -0500
X-Google-Sender-Auth: c8ICXF98_q5hnrAhaXjScrwvDBk
Message-ID: <AANLkTikYdrNSn7of7fcwgXwQqDaHTD3Vcuh1=MAKP_dB@mail.gmail.com>
Subject: Re: [PATCH v5] SCSI host lock push-down
From: Jeff Garzik <jeff@garzik.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 15, 2010 at 11:10 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>
>> Move the mid-layer's ->queuecommand() invocation from being locked
>> with the host lock to being unlocked to facilitate speeding up the
>> critical path for drivers who don't need this lock taken anyway.
>
> Looks ok to me. How should I take this? Just as a patch? Or should it
> go through the scsi tree?

Directly as a single patch (v5), if James acks; otherwise through
jejb/scsi-rc-fixes.git I would presume.

     Jeff
