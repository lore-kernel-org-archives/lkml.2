Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2KHBCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:02:10 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48474 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2KHBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:02:08 -0500
MIME-Version: 1.0
In-Reply-To: <509A915B.30105@redhat.com>
References: <509A915B.30105@redhat.com>
Date: Wed, 7 Nov 2012 18:02:07 -0700
Message-ID: <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
Subject: Re: scsi target, likely GPL violation
From: Jon Mason <jdmason@kudzu.us>
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 9:50 AM, Andy Grover <agrover@redhat.com> wrote:
> Nick,
>
> Your company appears to be shipping kernel features in RTS OS that are
> not made available under the GPL, specifically support for the
> EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
> full Vmware vSphere 5 VAAI support.
>
> http://www.risingtidesystems.com/storage.html
> http://www.linux-iscsi.org/wiki/VAAI
>
> Private emails to you and RTS CEO Marc Fleischmann have not elicited a
> useful response.
>
> You are subsystem maintainer for the in-kernel SCSI target support
> (drivers/target/*), and your company appears to be violating the GPL.

The peanut gallery needs more information, as this is quite an
incendiary claim to be making on a Linux kernel forum.  How are they
violating the GPL?  I'm not a lawyer, nor do I play one on TV, but if
I understand the GPL correctly, RTS only needs to provide the relevant
source to their customers upon request.  Are there customers (perhaps
Redhat) that they have not provided this to?  If so, then they need to
be publicly shamed (gpl-violations.org would be a good place to go as
well).  If not, then they are within their rights to behave the way
they are currently behaving.

Again, we need more info before we start flinging the tomatoes at them.

Thanks,
Jon

> Please explain.
>
> Regards -- Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
