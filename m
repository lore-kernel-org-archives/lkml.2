Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0GWSxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:53:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34495 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0GWSxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e/O2pSE2QF4F5oYEtrWTvJPvT8mOoPFsg0ZHhKx1YoAadqIyR9hyr9qqGVbdwd5K7z
         CzClJ+ZKRdZExWtYyhwGxxoA0AcIU3tL6Q47dgsKuDJc4qEn3jleh9K11Cp23s006cpa
         ++uIf/06oaqccU+jU7yxl9CLGLdWZUA23wKf0=
MIME-Version: 1.0
In-Reply-To: <20100717012742.GA11262@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com>
	<20100714143625.GA30721@srcf.ucam.org>
	<20100715223149.GC27512@khazad-dum.debian.net>
	<20100715225022.GA31377@srcf.ucam.org>
	<20100715230023.GE27512@khazad-dum.debian.net>
	<20100715230825.GA31651@srcf.ucam.org>
	<20100716030107.GH27512@khazad-dum.debian.net>
	<20100716200824.GA7142@srcf.ucam.org>
	<20100717012304.GA27741@khazad-dum.debian.net>
	<20100717012742.GA11262@srcf.ucam.org>
Date: Fri, 23 Jul 2010 19:53:16 +0100
Message-ID: <AANLkTilAZqTOl7d2VIKg7dulYPwSKBbZzEISwnA036Hn@mail.gmail.com>
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

On 17 July 2010 02:27, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Jul 16, 2010 at 10:23:04PM -0300, Henrique de Moraes Holschuh wrote:
>
>> I'm confused.  Is it the PCI reboot vector, or the ACPI reboot vector
>> that acts instantly?  The bug reporters say that they use reboot=pci to
>> have instant reboot, in this thread...
>
> The PCI one, since it's a function of the chipset. The ACPI one would
> act instantly (it's the PCI one, in this case) but it's marked as
> unsupported. However, the PCI one is poorly standardised - Windows never
> uses it, different chips have subtly different requirements and so on.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

So what should be done then? This is not the most annoying of bugs,
but still a bug.

Regards,
Pedro
