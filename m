Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966248Ab0CPN5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:57:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:54656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0CPN5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:57:19 -0400
Message-ID: <4B9F8E1A.2020608@kernel.org>
Date: Tue, 16 Mar 2010 22:56:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>
In-Reply-To: <1268745897.21384.14.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 13:56:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On 03/16/2010 10:24 PM, James Bottomley wrote:
> For msdos labels, it's embedded in the label ... for all other labels,
> it's made up on the spot.

Where in the label?

Thanks.

-- 
tejun
