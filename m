Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab2KPJr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:47:27 -0500
Received: from canardo.mork.no ([148.122.252.1]:49046 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2KPJr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:47:26 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-kernel@vger.kernel.org,
        celinux-dev@lists.celinuxforum.org, Ryan Mallon <rmallon@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] LDT - Linux Driver Template
Organization: m
References: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
	<20121115224030.GA16377@kroah.com>
Date: Fri, 16 Nov 2012 10:46:18 +0100
In-Reply-To: <20121115224030.GA16377@kroah.com> (Greg KH's message of "Thu, 15
	Nov 2012 14:40:30 -0800")
Message-ID: <87zk2hubh1.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

>  Normally you just start with a
> driver for a device like the one you need to write and modify it from
> there.

Yes.

Even if the template driver is fixed up to be the most beautiful driver
ever made, it will still always be made for non-existing hardware.  This
causes two major problems:
 - the driver will not be tested, so it will have bugs
 - the driver will not be used by anyone, so it will not be maintained
   (remember that it is initially perfect, so there is no reason to
   change it)

May I suggest another approach?  How about selecting a set of existing
drivers which are suitable as templates, and put all this effort into
making those drivers *the* perfect examples instead? Start submitting
cleanup patches for the selected drivers until everyone is satisfied and
then document them as starting points for anyone wanting to write a
similar driver.

I believe many subsystem maintainers already have such sample drivers
which they point new submitters to when asked.  That does not mean that
these drivers necessarily are perfect, so there is still work to do here
for anyone interested.  And collecting this information and documenting
it would be useful in itself.

It would also be nice if hardware availability was considered when
selecting the sample drivers.  Buying an already supported device to
experiment with its driver can be useful even if you have another device
you want to write a driver for.  Or just for the learning experience.

Just my € .02


Bjørn
