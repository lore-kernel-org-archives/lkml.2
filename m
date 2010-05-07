Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0EGJOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:14:04 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34903 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0EGJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bH3l0p1E2eF54PbQ+HzOr7+73wna1O9LjdLqfHCt3kDahHseWFkuT/1RfdxfiVqsR1
         5Uv771zNU6fyYvKPizmGE358jHFgVZYSA5DGhTyfdk9Fe9OXtJzyI6TKYY1b8r4wlzYB
         952UEn0tzfgdHx/n3ueJ/5V+HTIeKGK2zQ0MM=
MIME-Version: 1.0
In-Reply-To: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 7 May 2010 11:13:57 +0200
Message-ID: <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan is this patch set OK?

Sorry if you're busy, just need to check...

Patches 1 thru 4 should be uncontroversial, only affects
our ST-Ericsson platforms and have been thorougly reviewed.

As posted elsewhere this is tested on an ARM reference
design now as well, which IMHO would make it OK to apply
also the PL011 patch, nr 5.

(OK Russell?)

Nr 6 and 7 depend on changes in Russells -next branch
so unless you want to bring in the ARM next to your tree
as well, you can wait with these.

Yours,
Linus Walleij
