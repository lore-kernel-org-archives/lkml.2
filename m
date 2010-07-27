Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0G0RML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:12:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58568 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0G0RMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=jOz7tkJ1L5Yl0CdruP+NYneWBLujWOmj8B1C/Ze0CYaQpNFVeTy90+aTNpm51FmgM2
         hjC0PxgkeRFgAXF5+DNn3MkwpvBZHwk0M50zhFSJWNhgWgTflg/BmKfi7yh32FykBD+x
         PhXEZyTD0aN2eNUFWN2i6bT+PHGINx+XylkoY=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <20100727165549.GC26649@merkur.ravnborg.org>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
Date: Tue, 27 Jul 2010 18:12:08 +0100
Message-ID: <AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: trapDoor <trapdoor6@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 5:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jul 27, 2010 at 03:46:45PM +0100, trapDoor wrote:
>> Hello,
>> I've just got lucky and found this little typo under "Power management
>> and ACPI options"  ---> "ACPI (Advanced Configuration and Power
>> Interface) Support":
>> hArdware Error Device
>>
>> Here is my fix:
>> Hardware Error Device
>> :)
>>
>> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>
> The capital "A" is nconfigs way to tell you that you can use
> "a" as shortcut to reach the menu.
>
>        Sam
>

Rignt! So it's just a 'mnemonic' and only appears like that in nconfig
(I see that now). I'd guess that if I've ever made any use of
mnemonics here.

Thanks for clarifying and sorry for making needless 'noise'.

-- 
Regards
trapDoor
