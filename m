Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0GDKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 06:53:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54543 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab0GDKxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 06:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bn75RsqOV+qw33eeMZ5B95w2UjAnxsPNMw68VJ7brv2ig1cvbi2Qf93odj0ujgbgVz
         v1JvofozmvOt2Pkyo5l71cIEPCWMRtzWZ6/Hl9Gt4z6hE96Ok0oL3GWoYRFmMj9XyQag
         9By9Xw+h9Qapy4BscVvTyzqe7Jsb+zksCKH54=
MIME-Version: 1.0
In-Reply-To: <20100623224150.GA6680@kroah.com>
References: <1277298125-17991-1-git-send-email-ohad@wizery.com>
	<1277298840-18516-1-git-send-email-ohad@wizery.com>
	<20100623224150.GA6680@kroah.com>
Date: Sun, 4 Jul 2010 13:53:52 +0300
Message-ID: <AANLkTik0rm12w4jplD1vSTZnPbwguDU6xtOdAfs9C-3r@mail.gmail.com>
Subject: Re: [PATCH 11/11] staging: ti dspbridge: enable driver building
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 1:41 AM, Greg KH <greg@kroah.com> wrote:
> The default is always 'n' so you don't need this.
>
> Also, this enables the driver to be built on x86, which fails horribly,
> and I don't think is what you really want to have happen :)
>
> So I need some more Kconfig changes here, care to redo just this one
> patch?  I've applied all the others and they will show up in linux-next
> tomorrow.

I fixed all that stuff some time ago:
http://article.gmane.org/gmane.linux.ports.arm.omap/36065

But the patches were ignored.

I might rebase them if nobody beats me to it.

-- 
Felipe Contreras
