Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0KUB3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:29:45 -0500
Received: from hera.cwi.nl ([192.16.191.8]:35472 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0KUB3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:29:44 -0500
Date: Sun, 21 Nov 2010 02:29:16 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: ide boot failure 2.6.36/2.6.28 - 2.6.27 works
Message-ID: <20101121012916.GC8365@iq>
References: <20101120032828.GA14693@iq>
 <20101120074508.GA16854@liondog.tnic>
 <20101120121121.GA30338@iq>
 <20101120130401.59d8b8a1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120130401.59d8b8a1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> On a PCI box however you should always have a matching PCI driver,

True - in this case PIIX4, and selecting it makes things work
(but was not required earlier).

> If you have a PCI ATA driver which is not handled by any of the libata
> drivers and is not known by ata_generic then please let me know.

Also libata needs the additional selection of PIIX4,
but then works fine. (Of course all devices are renamed.)

Andries


> if its hitting a lot of people

Maybe a few hundred visible via Google.
One in every hundred thousand users?

---
Post by Thomas Ingerslev 2009-09-02
I have been struggling with error this fore quite a while,
and have finally found a solution.
... I ended up with just adding ide_generic.probe_mask=0x03 ...
