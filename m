Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab0GPLCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:02:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50027 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078Ab0GPLCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qQM5iwYDqVWy/JotEyLqbp5MA5aYCfM+Mxpo80rOZWWqu4WnF8zOrY7cv25HE7fvOu
         rMs2STzRgtvdVHY8X9uCy4cBSSYIWHm4DcWpoJ9Q4r2/5jWBzAlS/Q9Wztr+w9kPZ9E3
         guaHtR8bD5y/B9bKKEjsYYw3AbrVYhwdaW1pg=
MIME-Version: 1.0
In-Reply-To: <20100715230825.GA31651@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com>
	<20100714143625.GA30721@srcf.ucam.org>
	<20100715223149.GC27512@khazad-dum.debian.net>
	<20100715225022.GA31377@srcf.ucam.org>
	<20100715230023.GE27512@khazad-dum.debian.net>
	<20100715230825.GA31651@srcf.ucam.org>
Date: Fri, 16 Jul 2010 12:02:23 +0100
Message-ID: <AANLkTimn4vX72nE8oOKaQ-tfTFIquzrbvhWD3ANkg2p6@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on Lenovo 
	T400/T500
From: Pedro Ribeiro <pedrib@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2010 00:08, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Jul 15, 2010 at 08:00:23PM -0300, Henrique de Moraes Holschuh wrote:
>
>> Do you want to escalate this to Lenovo?  I need a clear and consise
>> description of the problem and the boxes we know to be affected.
>
> Well, right now we're not doing precisely what Windows does. The other
> possibility is that when the keyboard controller write triggers some SMM
> code, it makes an assumption about some piece of hardware state that
> isn't true and loops for a while to see if it changes. If we knew what
> that was then we could ensure that we're performing the same state
> change on our way down to reboot.
>
> One thing that would be worth checking is whether performing the
> keyboard controller writes from userspace with a minimal kernel and
> init=/bin/bash shows the 9-second pause or not - and then, ideally, see
> whether the same is also true under DOS.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

I'm available to try and test whatever you want on my machine .

Regards,
Pedro
