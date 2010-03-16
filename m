Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966291Ab0CPOVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:21:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966260Ab0CPOVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:21:54 -0400
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
In-Reply-To: <4B9F8E1A.2020608@kernel.org>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>
	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>
	 <4B9F8E1A.2020608@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 07:21:37 -0700
Message-ID: <1268749297.21384.15.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 22:56 +0900, Tejun Heo wrote:
> Hello, James.
> 
> On 03/16/2010 10:24 PM, James Bottomley wrote:
> > For msdos labels, it's embedded in the label ... for all other labels,
> > it's made up on the spot.
> 
> Where in the label?

No idea ... I only know you can use fdisk expert mode to change the
C/H/S layout and the change is preserved across reboots.

James


