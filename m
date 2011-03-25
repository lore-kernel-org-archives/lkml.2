Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1CYVRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:17:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45521 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1CYVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=dLgc3cgvTmB18QdddRF/qDO1+sUcm4DcxTIxRTiwmdWc09zqmKLMXb/jMV/bMqzAeN
         P4CQGDRql7riuoZoc3Rtuu5JAhh0qtbhrlQXF2dsIDlzLTxAaheVZNIajDdGmTNrXJHW
         gPXqxYVJSRx/VmMPHOnMZmatvV6lyeqIyhRa8=
MIME-Version: 1.0
In-Reply-To: <20110325133039.521553268@linutronix.de>
References: <20110325133039.521553268@linutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:17:11 -0400
X-Google-Sender-Auth: b78lRAJTQmnXV_1o_vsvQGSAC90
Message-ID: <AANLkTi=AOXL==fgOwsY9ujFehYnsUFAQrvLy1CLwFEhu@mail.gmail.com>
Subject: Re: [patch 0/2] blackfin: Final irq cleanup
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
> this is the final cleanup and name space conversion, so that we can
> remove the deprecated code in the core.
>
> It would be nice to get this Linus wards for .39

does this require some other patch ?  a recent merge from another tree
broke Blackfin, so i need to push out stuff to Linus again anyways.
-mike
