Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0GAQPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:15:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab0GAQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:x-originating-ip
         :in-reply-to:references:date:message-id:subject:from:to:content-type;
        b=UERkJj4KqcY/drDHjr+frRwZ5shJ3/8lhn55iJVQj39fZuCxE8nKcgGbCy8+732Scx
         J/nBSOrPgsEX2/IPUCeanA/SQgqMNv0nyWdULWPNbLBtvO2BXHcCYPzHwht/yA8icK5H
         B4aM5NfBTfSIaVVkgMysL7rareQ6ldW7k0IAw=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:content-type;
        b=VWwppKhSSQVNGzF7r5JtDpoyFiwhNEB2Fo1fucOG0+ZHwsHEAhsuONrLsr/9LvImnR
         GWW5kHaWFLfq6dJEy2QTN7MOYbOh4ilSCazii9Qaw2GaEA8sHf1ah5kMETmFcFX+iTbD
         usKgeZZ7WTy0E2032yZ8EfhlCDPhOv0gml7EM=
MIME-Version: 1.0
X-Originating-IP: [193.174.122.53]
In-Reply-To: <AANLkTilN60yM1WFKUOep0KsvXedtdyfEuCVRTeg61cEH@mail.gmail.com>
References: <AANLkTilN60yM1WFKUOep0KsvXedtdyfEuCVRTeg61cEH@mail.gmail.com>
Date: Thu, 1 Jul 2010 18:14:59 +0200
Message-ID: <AANLkTimxI2LQMLYXUAup31ElSYEfl6uVX-zZaO5bx_03@mail.gmail.com>
Subject: Re: Fan control with kernel module "asus-laptop"
From: orschiro@googlemail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

I'm using a Lenovo Thinkpad SL500 in combination with the asus-laptop
kernel module. Everything is working quite fine, the last commit
brought excellent support for my laptop, except the support for cpu
fan-speed control. I remember to read somewhere that this feature was
planned to be included but it still isn't.

I'm aware that there is an inofficial module called lenovo-sl-laptop
that does exactly this but I prefer to use the official one.

Does anyone of you know when I can count with this feature?

Best regards

Robert
