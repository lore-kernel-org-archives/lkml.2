Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0IRTlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:41:25 -0400
Received: from infernal.debian.net ([87.230.26.131]:51115 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0IRTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:41:23 -0400
Date: Sat, 18 Sep 2010 21:41:17 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alex Riesen <raa.lkml@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guillaume Chazarain <guichaz@gmail.com>, Mat <jackdachef@gmail.com>
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser
 Cordless Mouse"
Message-ID: <20100918194117.GA4465@amos.infernal>
References: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
 <alpine.LNX.2.00.1009181954010.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009181954010.26813@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 07:56:40PM +0200, Jiri Kosina wrote:
> Does reverting of commit 8fe294caf8c868edd9046251824a0af91991bf43 fix the 
> problem please?

It does here.
