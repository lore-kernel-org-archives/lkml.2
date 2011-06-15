Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1FOHaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:30:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1FOHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gqGwDUpTrMuIo1YgygMSDgjvnAv6BcHgJeqTH2j6UODIIt2PWCC0PYW/plNC9o0Cfv
         pb//ITx2UGEBboZoQt2njJ48pFvHcK0YaKx7DqV4putSoA22gPURyzTeBTBIKEHpzXEO
         krYqJ3g0q+8TbjfHxS548PL3UKzTQFUH1JB6M=
MIME-Version: 1.0
In-Reply-To: <20110614164900.GR2353@legolas.emea.dhcp.ti.com>
References: <BANLkTimU+E8Y0_9+H2nsF6CMg66_TDH0LQ@mail.gmail.com>
	<BANLkTimL=+vaa7NB5FW192rZd08Gv-Z-OA@mail.gmail.com>
	<BANLkTik+TD1+k1hd-hEteE5OTeDrDAuMZQ@mail.gmail.com>
	<20110614164900.GR2353@legolas.emea.dhcp.ti.com>
Date: Wed, 15 Jun 2011 09:30:00 +0200
Message-ID: <BANLkTi==s4adWqt0uLhJHmeDe1H2RD_5Bw@mail.gmail.com>
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

I don't care much about pushing this into mainline. It's a bug and
it's up to kernel developers to fix that.
I was aware that kernel devs are bunch of lazy dicks and I'm not going
to do more work for one line patch.

Howg.

On Tue, Jun 14, 2011 at 6:49 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jun 14, 2011 at 04:58:40PM +0200, Skacore Systems wrote:
>> Sorry for the HTML,
>> There is a bug in s3c2410_udc driver, which triggers when using custom
>> UDC command for USB pull-up.
>> As a result driver is always calling user defined UDC command with
>> wrong parameter (S3C2410_UDC_P_DISABLE) instead of
>> just passing the parameter to the user defined function.
>
> please take a look at Documentation/SubmittingPatches and fix up your
> patch so that it can be applied. Also, when sending patches,
> scripts/get_maintainer.pl will give you a hint of who you should put on
> Cc ;-)
>
> --
> balbi
>
