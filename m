Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0LTCDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:03:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54394 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0LTCD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CgsQfyiopvUFTbDF2g8BN8BbRkowYzomZHYCs4SZ8y7tkkXh1PEox8sYF3iu261Y0h
         5D7zkwiMOaj0kc/gGAhgD/MLRCh+D3NVoNDdAfTR/Y78KfnT3e/IYMxYOphtCz1CCPlK
         2qy8LW4FRJM89kMfPNF5NQOCbsoXttHAawqb4=
MIME-Version: 1.0
In-Reply-To: <20101215081046.GB11920@core.coreip.homeip.net>
References: <AANLkTimW5ro7EQBgoqMLSxnEsVrinL2S+USu207-Nbh=@mail.gmail.com>
	<20101210213551.GE1630@core.coreip.homeip.net>
	<AANLkTimhgLyx=Di2yBimFWm=Hg5-2CGOxHfuB+Gb-9_Q@mail.gmail.com>
	<20101215081046.GB11920@core.coreip.homeip.net>
Date: Sun, 19 Dec 2010 19:03:26 -0700
Message-ID: <AANLkTi=gMYi8Dvv0V=if0e_c_YWYwFosZx-1h3JT0hSU@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: FULL TOS1900 device support
From: Azael Avalos <coproscefalo@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Sorry for the late reply.

I'll resend the patch with the changes you suggested, however,
I'll change the description since this patch does not add _FULL_
support to TOS1900 devices.

I recently got a new laptop (Qosmio X505-Q898), which turns out
it had a TOS1900 device as well, however, none of the known
methods activate hotkeys on this model.

Searching in the DSDT, I found a WMI interface, so if someone
is interested in having a look on the DSDT let me know so I
can attach the file.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
