Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0C3Kqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:46:37 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55658 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0C3Kqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kBEKcw+lPogD8Ai4vR+KJ+KrXNpWVckNcbeFWxfAsSnjRarxUYQiXgjeh2ZAaH4Y3c
         vLCQLGMIaaPhzRERONqgZSlHjlib9BOQRhoDhzRKvEmQoM8ZNpo7gGR59Tt+2HrMtLvN
         Ic/zRotU9fTimFIIrgzZQCCFudfkcs+4xkplo=
MIME-Version: 1.0
In-Reply-To: <20100323132719.GY5768@kernel.dk>
References: <8c4cf08c1003230428t274b8ca8y13d67d65b8830dd7@mail.gmail.com>
	 <20100323132719.GY5768@kernel.dk>
Date: Tue, 30 Mar 2010 12:46:34 +0200
Message-ID: <8c4cf08c1003300346j73f4c106s49e494bbf2b329e7@mail.gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
From: Pawel S <spawels13@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Ben Gamari <bgamari.foss@gmail.com>,
       tytso <tytso@mit.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/23 Jens Axboe <jens.axboe@oracle.com>:

> It's also been my sneaking suspicion that swap is involved. I had lots
> of RAM in anything I use, even the laptop and workstation. I'll try and
> run some tests with lower memory and force it into swap, I've seen nasty
> hangs that way.

I am not sure if the memory swapping is the case. According to KDE
System monitor swap is not even touched when copying files. I also
noticed similar responsiveness problems when extracting some rar files
- twelve parts , each about 100MB and the system becomes unresponsive
for some time since the first seconds of operation, then it behaves
normally and then problem is back. I have 2GB of RAM. I am using ext4
file system and I am using noatime mount option.

P.S. It seems it is a little better when I have AHCI mode set in BIOS
(at least when extracting archives).

P.S.2 I would be glad to provide some useful data. I created perf
chart, but if this is not enough just instruct me what should I do
next, please.

Regards

Pawel
