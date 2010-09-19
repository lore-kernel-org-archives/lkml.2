Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0ISJym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:54:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0ISJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=v7x22HLEEwfUUIHge8XZZN9h83wVzO3MzoRPhwmj2ZcceRIFznU+c/kOaudyez2DJc
         sjr1zeRpQWB7SPLID0n2UyzV7TMW1XT1DSuytl+jPw7uRf5RJTuCbmd64xrQCydtopVy
         YH8izb2r86eK4I/ENMCHkojIp3O+ZjbZMhXyM=
MIME-Version: 1.0
In-Reply-To: <20100915055649.GB22219@core.coreip.homeip.net>
References: <4C8F886E.2080407@vlnb.net>
	<20100915055649.GB22219@core.coreip.homeip.net>
Date: Sun, 19 Sep 2010 11:54:37 +0200
X-Google-Sender-Auth: _SImbbA5DvJzUyF4o15jFuQE4mk
Message-ID: <AANLkTi=d1ZYrOxP3iMt4+qE628FhzassD9=8Q1V+unNE@mail.gmail.com>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
From: Bart Van Assche <bvanassche@acm.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
        Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>,
        Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>,
        Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 7:56 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Hi Vladislav,
>
> On Tue, Sep 14, 2010 at 06:36:30PM +0400, Vladislav Bolkhovitin wrote:
> > Hi All,
> >
> > Please review this second iteration of the patch set of the new
> > (although, perhaps, the oldest) SCSI target framework for Linux SCST
> > with a set of dev handlers and 2 target drivers: for local access
> > (scst_local) and for Infiniband SRP (srpt).
> >
>
> [ ... ]
>
> And too many "naked returns", I believe common style is to only have
> return for non-void functions.

Hello Dmitry,

If there is agreement among kernel maintainers that return statements
at the end of functions that do not return a value should be avoided,
it might be a good idea to let checkpatch complain about such return
statements. Currently checkpatch doesn't complain about such return
statements.

Bart.
