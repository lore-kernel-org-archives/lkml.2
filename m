Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0ILQ1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:27:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63742 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0ILQ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m3jadYiqL59GSVpZoIp1vmq/wIS8n4Oy2NaCFxVJsgq7JUYxm4eB3bBWPRANww0OXM
         ZH7Qa0StSMJ+adjjzMjLNdYJQacvP06v9yfMkpz1IPzp6IEXkvT7zplr2UMtTle0oGzy
         bWrJ4HslO3N7jYBFzfujKk46kDO0x7m10t78Y=
MIME-Version: 1.0
In-Reply-To: <4C8CB5A1.9040500@tuxonice.net>
References: <4C8CB5A1.9040500@tuxonice.net>
Date: Sun, 12 Sep 2010 19:27:01 +0300
Message-ID: <AANLkTinRG1RN+xHEK0ZuF6T5ZHOUrav713L+67_Avtv3@mail.gmail.com>
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 2:12 PM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> Hi all.
>
> I'm unable to compile the latest kernel and git bisect isn't helping:
[...]

me too, but I think I have a different problem (on ubuntu 10.10):

dpkg-gencontrol: error: package linux-image-2.6.36-rc3+ not in control info
make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc3+] Error 255
[...]
make: *** [kernel_image] Error 2

The "not in control info" error in ubuntu was some versions ago. Verry strange.
