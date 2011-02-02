Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1BBJOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:14:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1BBJN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O88PKSTzrS29uERqhafKWPBEl9sjm2ub8lVpccPe5tL9dbrsFupr0XrFzMCWrNHlUJ
         r3dtWrw90PZrTBlE/KarQWI07TfP6Dh4/6JtqA2KWjdqfZGR5HRIlqBI6yGl4xJ/dtIK
         IQeWkiZoFv9KZNm0Yp/lU1aAA9XxfR6a2Bu2o=
MIME-Version: 1.0
In-Reply-To: <4D48B24B.8020305@lwfinger.net>
References: <1296607614-5326-1-git-send-email-mark.einon@gmail.com>
	<4D48B24B.8020305@lwfinger.net>
Date: Wed, 2 Feb 2011 09:13:57 +0000
Message-ID: <AANLkTikXfScGU93epfcgHXrBQwDELdGS1y8zeHkpu=n4@mail.gmail.com>
Subject: Re: [PATCH] Staging: rtl8712: Switch from large inline firmware file
 to use the firmware interface
From: Mark Einon <mark.einon@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: greg@kroah.com, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

    I don't think these patches are equivalent, could you explain what
you mean? I can't find an equivalent use of request_firmware() in the
driver prior to this patch, or from the Jan 14 changes.

Regards,

  Mark

On 2 February 2011 01:24, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 02/01/2011 06:46 PM, Mark Einon wrote:
> > As per the drivers/staging/rtl8712/TODO file. Relevant firmware
> > already present in linux-firmware package.
> >
> > Signed-off-by: Mark Einon <mark.einon@gmail.com>
> > ---
> >  drivers/staging/rtl8712/farray.h   |10197 ------------------------------------
> >  drivers/staging/rtl8712/hal_init.c |   36 +-
> >  2 files changed, 16 insertions(+), 10217 deletions(-)
> >  delete mode 100644 drivers/staging/rtl8712/farray.h
>
> The equivalent of this patch was sent to GregKH on January 14,
>
> Larry
