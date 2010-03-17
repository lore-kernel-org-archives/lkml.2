Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0CQCFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:05:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:46957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0CQCFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:05:52 -0400
Message-ID: <4BA038CB.8050400@kernel.org>
Date: Wed, 17 Mar 2010 11:04:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>	 <4B9F8E1A.2020608@kernel.org> <1268749297.21384.15.camel@mulgrave.site>	 <4B9F9AAF.6080709@kernel.org> <1268751748.21384.18.camel@mulgrave.site>	 <4B9FA1C6.7090305@kernel.org> <1268752993.21384.23.camel@mulgrave.site> <4B9FA59E.1000402@kernel.org> <4B9FED32.6080400@redhat.com>
In-Reply-To: <4B9FED32.6080400@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 02:05:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ric.

On 03/17/2010 05:42 AM, Ric Wheeler wrote:
> Dropping any mention of CHS seems to be the only sensible thing. Why
> waste any time to continue some myth about drives that no modern
> hardware supports (and then have the joy of explaining that to users)?
> 
> Talking about it only confuses people and in the worst case, could cause
> them to misalign their partitions by clinging to these pretend borders :-)

I don't think not mentioning it would clear up the myth.  It would
probably be a good idea to beef up the document to clear
misconceptions around disk geometry.  I'll give a shot at it.

Thanks.

-- 
tejun
