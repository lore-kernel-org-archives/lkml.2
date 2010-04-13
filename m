Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0DMPOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:14:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63036 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0DMPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qQG3DSvDyXD51bj7W9xbqpuOxe1egdQvIuTY9vqpH0y1mHM8P8G3HaSO35e2pmULIR
         nE+2P+JXiPZBkpqyP+FOedxa/GFUHPnIGOv3dRL6/aIafO17hnIGg817yJIa95GNyMPT
         jx0BX+J7ycjhIm4utO+yZLXQBV1JrVAuwZFmA=
MIME-Version: 1.0
In-Reply-To: <1271136656.22314.3.camel@bnru03>
References: <1271113496-6744-1-git-send-email-linus.walleij@stericsson.com>
	 <1271136656.22314.3.camel@bnru03>
Date: Tue, 13 Apr 2010 17:14:20 +0200
Message-ID: <v2l63386a3d1004130814i6c834d6boa105d4f7491cb01b@mail.gmail.com>
Subject: Re: [PATCH 1/3] MFD: renamed ab3100.h to abx500.h
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: srinidhi.kasagar@stericsson.com
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Mattias WALLIN <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/13 srinidhi <srinidhi.kasagar@stericsson.com>:

> So do you expect the existing ab4500 also to be merged into abx500?

Don't think so, the 4500 is not related to the 3100, 3550 and 5500:s,
so they don't have much in common, whereas the latter share a lot of
characteristics. It's better if it stays where it is I think.

abx500 was the best name we could come up with that wasn't too
short, we contemplated abx.h but it was too short, abxxx0 looks
silly and so on. So abx500 denotes our largest family of mixsig ASICs
which has a lot in common, i.e. everything except the
AB8500/AB4500/STw4500, hope it's not too confusing...

But the ab4500 files should be renamed ab8500.[c|h] after current
product naming decisions though.

Yours,
Linus Walleij
