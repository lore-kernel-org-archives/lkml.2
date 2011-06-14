Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1FNSSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:18:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1FNSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:18:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
Date: Tue, 14 Jun 2011 20:17:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Jim Cromie <jim.cromie@gmail.com>,
        linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com> <201106141607.02171.arnd@arndb.de> <BANLkTinrbrsEORxMd96K2obvfGjswegP+g@mail.gmail.com>
In-Reply-To: <BANLkTinrbrsEORxMd96K2obvfGjswegP+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106142017.41558.arnd@arndb.de>
X-Provags-ID: V02:K0:RBfKu3WWuEnt2r7Mi6b9sITtaYLGWi8myYQGJOXsdrc
 QUVL0lxWieVI6BSH540hB2iPb8MAAoc+UVVGSzs3Rf71BOTvcu
 U/SQ4N58P4TlYdHu6dwf3qMyb/90j/ClL8ORul6ICroWkV8OAF
 NAeYReTPaZr0S3bV6wwACYLBLvz236Z/cBEeRUi9dfZTFphcdb
 sXUMGbcV+dLeFChuO30Pw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 18:23:50 Grant Likely wrote:
> On Tue, Jun 14, 2011 at 8:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> > On the topic of drivers/char/{nsc_gpio,pc8736x_gpio,scx200_gpio}, I wonder
> > if we should move them to drivers/gpio/nsc_gpio despite the fact that they
> > use a different (older) interface than all the other gpio drivers.
> 
> I have no problem with moving them into drivers/gpio.  When you do,
> please rename then drivers/gpio/gpio-*.c

Ok. Should they be in a subdirectory drivers/gpio/nsc_gpio/gpio_* for the
nonstandard API or do you prefer them to live amongst the regular ones?

	Arnd
