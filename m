Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1FTQHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:07:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63603 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1FTQHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x4M1+UkvIb201WPp74R9zOLUnwIM5COibHPflVOm0/tkN35GgrFIhGTfFh+c5Q0Kne
         ZI0R12k9EFuuSMoRFKMIaHjnqh1BXfqc0Vv8+61vG+QFW7cPAAq2KBPQYdOCF6EkROD1
         mbO5gG3YtVnX4HMZoUGPMQvuHydsQEJT6/uno=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
	<Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
	<20110620151522.GN14262@legolas.emea.dhcp.ti.com>
	<BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
	<20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
	<BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
	<BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
Date: Mon, 20 Jun 2011 21:37:38 +0530
Message-ID: <BANLkTinF6tqVGf6pL+GM9-u_W9DsVdCokg@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Skacore Systems <skacore.systems@gmail.com>
Cc: balbi@ti.com, David Brownell <dbrownell@users.sourceforge.net>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 9:27 PM, Skacore Systems
<skacore.systems@gmail.com> wrote:
> Oh and I've finally cloned the mainline git. So here it's the last try.
> I hope the TI people will not sabotage the Samsung's drivers any way longer !!!
>
> Vilo

If you already cloned the git, it'd do good to have a quick look at
the output of 'git log'
and see how patches are supposed to be.  And hopefully you'll realize
the following
wouldn't look much useful if someone did 'git log' over your patch.
"
Oh and I've finally cloned the mainline git. So here it's the last try.
I hope the TI people will not sabotage the Samsung's drivers any way longer !!!
"
