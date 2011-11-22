Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab1KVU0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:26:12 -0500
Received: from mail2.unitix.de ([176.9.2.175]:42864 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab1KVU0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:26:10 -0500
Message-ID: <4ECC0560.7010502@arndnet.de>
Date: Tue, 22 Nov 2011 21:26:08 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@canonical.com>
CC: linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: 3.2.0-rc2: kernel BUG at fs/ecryptfs/crypto.c:348! regression?
References: <4ECB62F4.6060602@arndnet.de> <20111122155149.GB6006@boyd>
In-Reply-To: <20111122155149.GB6006@boyd>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

Am 22.11.2011 16:51, schrieb Tyler Hicks:
> On 2011-11-22 09:53:08, Arnd Hannemann wrote:

>> 
>> I'm regularly hitting below BUG (also with yesterdays Linus git): 3.1.1 is working.
> 
> Please give this patch a try:
> 
> http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/18
> 
> Here's a link directly to the patch in the eCryptfs git tree but the link might not stay around for much longer:
> 
> http://git.kernel.org/?p=linux/kernel/git/tyhicks/ecryptfs.git;a=patch;h=45608c8eb41a6deab47876ae2679117820006d25
> 
> I plan on upstreaming this patch in the next day or two, so please let me know whether or not it fixes your problem.

until now its looking good. No BUG hit with recent linus git and above patch applied.

Best regards
Arnd
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7MBVQACgkQZyJJMjKQIYQizACguX3yXPXG3x61gOZ9uDCRsGd2
YD8AoLBdedR33cxKbaSmH76kCr/J7GKn
=Exjt
-----END PGP SIGNATURE-----
