Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1EWOJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:09:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46312 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1EWOJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pErbhKFpp78hrUasMa6cY1nB3fBWKe0O5zUM8GSL68bJL19rRleLwFty8xQFXW63dG
         O1XdIFI/AMFlThXNOOSmwh8DukAbMb8COMSjtSrV1cZPxRqp75w9L3f+ibRRtyp9OeCf
         RjxHpjOisCjrSegzhgRQNsOMxumOYNutT6taM=
MIME-Version: 1.0
In-Reply-To: <20110523144159.5788ee9f@lxorguk.ukuu.org.uk>
References: <20110511204609.GA6059@patrik-macbook>
	<20110511225557.2c8f6649@lxorguk.ukuu.org.uk>
	<BANLkTi=tB+22Xen9StHkCdoEa8A2hqA2aA@mail.gmail.com>
	<20110523144159.5788ee9f@lxorguk.ukuu.org.uk>
Date: Mon, 23 May 2011 16:09:52 +0200
Message-ID: <BANLkTinssZiR1E+=b4Rfd1pu3mX_6uidSQ@mail.gmail.com>
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight (try 2)
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 3:41 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> So my question is, do you think we should incorporate the new and more
>> feature complete output handling from the i915 into gma500? We might
>> even start sharing that code between gma500 and i915. If that is
>> something you like to avoid we can of course keep working on our
>> current output code.
>
> Importing the code seems reasonable. KeithP didn't want it shared when I
> asked him, but importing it and having the same code in many areas is the
> first step to sharing anyway.
>
> Alan
>

Ok, I'll get back to you (probably after the weekend) when I've had
some more time to work on this.

Anyone who would like to look more closely on the LVDS parts of gma500
vs i915 are free to join in.

Thanks
Patrik Jakobsson
