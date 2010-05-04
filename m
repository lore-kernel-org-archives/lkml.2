Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab0EDUGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:06:54 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:45397 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab0EDUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dIUbQEQ5hjrhMtg9SYiNeZtz3Vxz96AqdmRi9nbHOTdTynSTvQ1O59UYYL4BQKopZX
         RIzPTTsNZ0gbaay6lhtdcP255okMPgEFvuqW2eEJpPXw2laGGIPdrTo5/PP2tAgM9Lot
         COKQkX+hcPyx73vg+8ZHOoQ3BHkRSDOMRIi4k=
MIME-Version: 1.0
In-Reply-To: <1272978272.3702.5.camel@localhost>
References: <1270891582.4704.102.camel@macbook.infradead.org>
	 <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
	 <1272354388.26036.4.camel@localhost>
	 <1272978272.3702.5.camel@localhost>
Date: Tue, 4 May 2010 13:06:51 -0700
Message-ID: <i2w347733d51005041306q4b1d9f0bzd2206805c96cbad2@mail.gmail.com>
Subject: Re: [PATCHv2] MTD: Suppress warnings in inline_map_read()
From: Kevin Cernekee <cernekee@gmail.com>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 6:04 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h: In function 'inline_map_read':
> /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h:390: error: implicit declaration of function 'BUG'

I did test my patch, but it didn't generate any warnings or errors on MIPS...

Could you please apply this patch and retry:

http://lists.infradead.org/pipermail/linux-mtd/2010-May/029904.html

<linux/bug.h> should probably be added anyway since there are two
other BUG statements in that file.

Thanks.
