Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1BHRdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:33:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45690 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1BHRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mPSrFwRHrFTuoyv8AWn8Dn4Fc8XlwVg63XNTguzp/rVpmvMLMgCwcPAl6VPLigzABv
         mOfS054c3LKV87/vl7rEwjuzvc2sJRWs9Rn376GsfN8JczSLUhiMn9Ew+OOdrB0uQPGY
         YQdwf6299IF/vlbXltmVapNwOcTCreEEKq9+Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTin-RGqvUDT-GOBQkP2Rn6+2w7AWarSKHseLSORc@mail.gmail.com>
References: <AANLkTinLOSfdO0HVABANiBnKgN540fc0pzqhjDAKAa2B@mail.gmail.com>
	<AANLkTin-RGqvUDT-GOBQkP2Rn6+2w7AWarSKHseLSORc@mail.gmail.com>
Date: Tue, 8 Feb 2011 12:33:47 -0500
Message-ID: <AANLkTint8uzHC2ELFRgaopZpqwo9oXa4Yy8xcQfBCW9r@mail.gmail.com>
Subject: Re: Regarding Buddy Allocator
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Santosa, Not much is mentioned in the link you mentioned.

I looking for more of explanation and optimal implementation. Any
reference would be good too.

--Sri

On Mon, Feb 7, 2011 at 9:52 PM, Mulyadi Santosa
<mulyadi.santosa@gmail.com> wrote:
> On Tue, Feb 8, 2011 at 06:29, Sri Ram Vemulpali <sri.ram.gmu06@gmail.com> wrote:
>> Can anyone point me to implementation of buddy allocator, with
>> efficient data structures used. Thanks in advance.
>
> I think, indirectly, you can read about buddy allocator in here:
> http://lxr.linux.no/#linux+v2.6.37/Documentation/vm/
>
>
> --
> regards,
>
> Mulyadi Santosa
> Freelance Linux trainer and consultant
>
> blog: the-hydra.blogspot.com
> training: mulyaditraining.blogspot.com
>



-- 
Regards,
Sri.
