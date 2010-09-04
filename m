Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0IDPgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:36:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55871 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0IDPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tf94zWVjsld8qg3eW0gW7qgSYSV3gglf55vhQnzhXsn83BMU9b3W1RclJUswsS9QM5
         E6hm3rnXYdQswI76qrzb8QpqJHBOIuFI1CgiMOISDAtAM77ve5rTcZGjQzoxRPd1grCO
         VNVVPFyAjxRJj4JDmtrA7MkEQRDuSoZS928Dg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com>
	<ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com>
	<AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com>
Date: Sat, 4 Sep 2010 23:36:39 +0800
Message-ID: <AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization
From: Ming Lei <tom.leiming@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

Considered bit PHYPWD of PHY_PWR_CTRL is zero at default,
say, OTG phy is not put into power down after system poweron,
so 2.6.36-rc3 will make musb device mode broken if bootloader
doesn't touch  PHYPWD of PHY_PWR_CTRL.

Could you ack the patch if no further objections or give other
suggestions?

thanks,

-- 
Lei Ming
