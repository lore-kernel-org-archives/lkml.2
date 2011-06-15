Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1FOIno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:43:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1FOInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SFBC5J+MswxqzmRFziIbXtU4PwpBLBzBtMLALpb0MGSZR5AvUSUFQgNwEPak8ymotG
         hHar1UHAL3Nm8EvgGQ0v1/36rnY46AvOQ8FQt6JM3FW6B7Po9GhsDjshwSHkATj4FV1c
         KZ3HVEVdKRfJwwpCMetvjFeDRzCTzSiICTfdU=
MIME-Version: 1.0
In-Reply-To: <20110615083811.GD31876@legolas.emea.dhcp.ti.com>
References: <BANLkTimU+E8Y0_9+H2nsF6CMg66_TDH0LQ@mail.gmail.com>
	<BANLkTimL=+vaa7NB5FW192rZd08Gv-Z-OA@mail.gmail.com>
	<BANLkTik+TD1+k1hd-hEteE5OTeDrDAuMZQ@mail.gmail.com>
	<20110614164900.GR2353@legolas.emea.dhcp.ti.com>
	<BANLkTi==s4adWqt0uLhJHmeDe1H2RD_5Bw@mail.gmail.com>
	<20110615083811.GD31876@legolas.emea.dhcp.ti.com>
Date: Wed, 15 Jun 2011 10:43:41 +0200
Message-ID: <BANLkTi=XvUxyATWPB19xk9xB37a0uk8Lsg@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: udc command always disables pull-up instead
 of passing the command
From: Skacore Systems <skacore.systems@gmail.com>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're lazy. I've already fixed it where I needed. You just trolling
about some rules for one line patch.
I'm not wasting any more time in this discussion.

On Wed, Jun 15, 2011 at 10:38 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Jun 15, 2011 at 09:30:00AM +0200, Skacore Systems wrote:
>> I don't care much about pushing this into mainline. It's a bug and
>> it's up to kernel developers to fix that.
>> I was aware that kernel devs are bunch of lazy dicks and I'm not going
>> to do more work for one line patch.
>
> You are the lazy dick here. All I asked was to follow our standards, do
> you have any idea how many patches each kernel maintainer has to go
> through ? It doesn't scale if we have to re-format the ugly crap you
> send us.
>
> Get over yourself and if you want this fixed, then send a proper patch.
>
> It's just a small set of instructions we are asking you to follow, try
> saying the same to your Income Tax office and see if they'll like that
> you didn't follow their instructions.
>
> Lazy dicks... hah... the one who can't get a simple set of instructions
> right is calling us lazy dicks. What a prick!
>
> --
> balbi
>
