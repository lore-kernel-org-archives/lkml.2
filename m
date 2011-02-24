Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BXNUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:20:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58004 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1BXNUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:20:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWltCDTvDdhVp2EWEXFUqu07VY0ZlPTIO3RFdIt4Oui7CC1/t71jEBwMPWx7L8JHMH
         vKxPQ/Tkq/U1/J1XAr6D1SmalSzEL6vgGy9DdjsQGau6uzBfSxym58Ad9T6+MZF/xzEd
         v1O1mQF9MFjPDCV7wnmie/2kK19MIqg+o25BA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
	<20110222140349.GA20708@kryptos.osrc.amd.com>
	<AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
	<AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
	<AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
	<AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
	<AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
Date: Thu, 24 Feb 2011 15:20:19 +0200
Message-ID: <AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 2:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Feb 23, 2011 at 9:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>>
>>> Looks like nouveafb took over from vesafb. Did you do anything special
>>> to trigger this?
>>
>> No. Just boot the system.
>
> Every boot?

Yes.

>
> And just out of interest, what happens if you don't have the vesafb
> driver at all?
>
>                          Linus
>

I used 'e' option from grub, removed the 'set gfxpayload = $linux_gfx_mode'
and it works.

dmesg: http://pastebin.com/JAZsk4vD
