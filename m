Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1FMHRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 03:17:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1FMHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 03:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=uO0qYzQXK3518nAx+n7427tTfeW6VTrbQ0ImOS3iZsyMu7R9Yerch8PProYIa4k1yY
         FExB5y/eU/sQtcSlWLnysXOOmiO3EUDGwlIGfRk985/zVFsN8NFsJzF8CkuIndTPTy9E
         lAaFcT08S39nFBMX0kqrRFm7cUhwr8MfLpYGc=
MIME-Version: 1.0
In-Reply-To: <4DF0B5C2.6030500@mev.co.uk>
References: <20110609115215.GA14569@mail.fossee.in> <4DF0B5C2.6030500@mev.co.uk>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Mon, 13 Jun 2011 12:47:33 +0530
Message-ID: <BANLkTin+2_HX7pLKEy8002QUpvMkYnvXgg@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: dyna_pci10xx: replace semaphore with mutex
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resending the patches again. Cleaned up the code a bit and
removed unwanted delays.

Regards.
