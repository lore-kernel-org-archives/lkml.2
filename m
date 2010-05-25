Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab0EYWCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:02:12 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:52640 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0EYWCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XeO2xW+y1qqjkwixWoB08QuRXri9yCZubVra2qvKC1eKiOlXLDLbIVnBvVtFRjEbyk
         ffm4CFztHI9jGAkfvIa6Nv2COi0J4ob3x7f6Y22OskNeMDVzVqwl+rHucp5H5z+ukoK1
         P+xv85Dc1ahpf54R18KhA5+2SxGratUTtnL1I=
MIME-Version: 1.0
In-Reply-To: <8739xflkn5.fsf@deeprootsystems.com>
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com> 
	<20100519000019.GA17475@core.coreip.homeip.net> <87mxvnlpxv.fsf@deeprootsystems.com> 
	<20100525202135.GC4455@core.coreip.homeip.net> <8739xflkn5.fsf@deeprootsystems.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 25 May 2010 17:56:27 -0400
Message-ID: <AANLkTik72Q50eHX5cLW4uZ13BiMVCKQ0_bKdrCGZxpeE@mail.gmail.com>
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-omap@vger.kernel.org, Michael Roth <mroth@nessie.de>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 17:46, Kevin Hilman wrote:
> After digging into the driver core and realizing that it seemed to
> have sane error handling itself, I took a closer look at
> ads7846_probe() and discovered it doesn't actually return an error
> code for certain failure cases!  That was the root cause.

that is crappy

> Subject: [PATCH] input: touchscreen: ads7846: return error on probe failure

i'd refer to the specific probe issue rather than just "probe".  maybe:
input: touchscreen: ads7846: return error on regulator_get() failure

otherwise:
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
