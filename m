Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0JQDuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 23:50:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61844 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0JQDux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 23:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iGOCytUn8tsOhO556j0MWLQX1iC/dfC9y2glCE4HHV9bbEChOYPIKCzhyk3uZXFGkO
         IzL76L2WQZpi7sPRWWwvzRYJPRJ11R5TsixOSyjtPDl/FgWRfqnAsqPKnpzkl4kC4HFJ
         0bjsbKXNrVToCajdl2xEvqgfaW/haZdHOl+c4=
MIME-Version: 1.0
In-Reply-To: <aday69xfvrn.fsf@cisco.com>
References: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
	<adad3r9hn1x.fsf@cisco.com>
	<AANLkTinsmKABCCmS77MX4UH4NPG2UnQKtoGEcp6hooBJ@mail.gmail.com>
	<aday69xfvrn.fsf@cisco.com>
Date: Sat, 16 Oct 2010 23:50:51 -0400
Message-ID: <AANLkTikSZOLhqR5mC9L95kkTR0_0Nad_Xs0dPjj_=9K2@mail.gmail.com>
Subject: Re: 2.6.36-rc8 -- drivers/built-in.o: In function `nouveau_acpi_edid':
 (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
From: Miles Lane <miles.lane@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>,
        Maarten Maathuis <madman2003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 9:33 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > I tried with your patch applied and got this:
>  >
>  > drivers/built-in.o: In function `load_vbios_acpi':
>  > nouveau_bios.c:(.text+0xa9cdf): undefined reference to
>  > `nouveau_acpi_rom_supported'
>
> I see, it's not that simple... you'd have to change the CONFIG_ACPI
> tests in nouveau_drv.h to be testing CONFIG_ACPI_VIDEO really.
>
>  > When I set CONFIG_DRM_NOUVEAU=m rather than =y, I got this:
>
> If you drop my patch and set CONFIG_DRM_NOUVEAU=m, does it work?
> It seems to me that it should.

Yes, it does.  (Sorry for the duplicate, Roland.  I keep forgetting to
CC everyone else)
M.
