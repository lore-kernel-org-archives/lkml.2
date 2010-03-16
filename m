Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278Ab0CPO0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:26:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0CPO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:26:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Date: Tue, 16 Mar 2010 15:25:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <vda.linux@googlemail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
References: <4B947393.2050002@kernel.org> <4B9F8E1A.2020608@kernel.org> <1268749297.21384.15.camel@mulgrave.site>
In-Reply-To: <1268749297.21384.15.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003161525.59364.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX185qQs0KEsA8Zjz6OoGCYRjFoHVV6Dajzd9JMW
 1aDZZCRVG5Vsilr/7g4PrCM1HY27LtJZVRjyi9lgNSdu8p9fp9
 34HYSyRw4TAMDo/ae4hFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010, James Bottomley wrote:
> On Tue, 2010-03-16 at 22:56 +0900, Tejun Heo wrote:
> > Hello, James.
> > 
> > On 03/16/2010 10:24 PM, James Bottomley wrote:
> > > For msdos labels, it's embedded in the label ... for all other labels,
> > > it's made up on the spot.
> > 
> > Where in the label?
> 
> No idea ... I only know you can use fdisk expert mode to change the
> C/H/S layout and the change is preserved across reboots.

IIRC, the layout is guessed from the partition end locations, in the
assumption that each partition is aligned to full cylinders. That
gives you the heads/sectors number, while the cylinder number can be
calculated from the total number of sectors using these numbers.

	Arnd
