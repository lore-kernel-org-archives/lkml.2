Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0JBHkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:40:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61973 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0JBHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:cc:content-type;
        b=IlGrXExfp4wGhDZp8PwJs26ETjcGfIPT8jcg0gT6Z9WLXHYdLHIgFoHNuW2nOYsrGU
         xcUZprNHL0WQiS8cEvqIJ/9rlX+A/Ewl5eeTNvV6W02XLRdB5BPmIvtvwugv1vxqnsHa
         pEXlUujocN/8l1WmtBDk8PDixYylXaL8+eDts=
MIME-Version: 1.0
In-Reply-To: <4CA653F0.1010008@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 2 Oct 2010 09:40:21 +0200
X-Google-Sender-Auth: kSLhTDHcMuvduyE0uwOYEXE7bao
Message-ID: <AANLkTi=bfGuL-wrdjYotQFH3x5e+-3H7jzmic9YNppbx@mail.gmail.com>
Subject: Re: [PATCHv4 0/19]: New SCSI target framework (SCST) with dev
 handlers and 2 target drivers
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 11:34 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> Hi All,
>
> Please review the next iteration of the patch set of the new (although,
> in fact, the oldest) SCSI target framework for Linux SCST with a set of
> dev handlers and 3 target drivers: for local access (scst_local), for
> Infiniband SRP (srpt) and IBM POWER Virtual SCSI .
>
> [ ... ]

Note: as far as I know currently SCST is the first and only in-kernel
target storage framework that satisfies both criteria (1) and (2) as
defined during the LSF 2010 summit storage track (see also
http://lwn.net/Articles/400589/):

1. Being a drop in replacement for STGT (the current in-kernel target
mode driver).
2. Using a modern sysfs based control and configuration plane.

Regarding criterion (3), that the code was reviewed as clean enough
for inclusion: any feedback is welcome.

Bart.
