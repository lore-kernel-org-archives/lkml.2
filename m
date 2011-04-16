Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1DPIFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:05:48 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:57959 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1DPIFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ov1c49noYRPCzX42k8pnMexluBd+NPnVigqyZOCOjy8pLt6dx6wRBsb32oyQyhbX9b
         PJxOKieLam+GyTjoFkPUFRCQRlhCPi3vsqwnifKjSsLGumvCCbzDPCOBQHafIMN3FoGV
         yRMSX+LvJJpQy5XuayRpgos1NxM3GGosPI2KM=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
Date: Sat, 16 Apr 2011 10:05:43 +0200
Message-ID: <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

Maybe could suggest something, it would be great.

Thanks

On Thu, Apr 14, 2011 at 9:13 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm writing a script to automatise some parts of my kernel compilation process.
>
> From those scripts I'd like to be able to call the top makefile the
> same way it had been called during its last invocation.
>
> For example, if Ido:
>
>     $ make CC=my-gcc CFLAGS="-g -fwhatever"
>
> I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
> the last invocation so my script can call make with the same
> arguments.
>
> Is this possible ?
>
> Thanks for any ideas
> --
> Francis
>



-- 
Francis
