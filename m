Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1AUWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:08:19 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:48678 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1AUWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:08:18 -0500
Message-ID: <4D3A03CA.2060507@afaics.de>
Date: Fri, 21 Jan 2011 23:08:10 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: how to avoid that install.sh goes mad, if I am not root?
References: <4D388A08.1010004@afaics.de>	<19768.44428.482148.361069@pilspetsen.it.uu.se> <ihbvd1$jbj$3@dough.gmane.org>
In-Reply-To: <ihbvd1$jbj$3@dough.gmane.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/21/11 13:49, WANG Cong wrote:
> On Thu, 20 Jan 2011 22:47:56 +0100, Mikael Pettersson wrote:
>>
>> First, at least on x86, the kernel will look for the 'installkernel'
>> executable first in your own ~/bin/, so if you have that then it will
>> override /sbin/installkernel.
>>
> 
> That still doesn't look like a good solution.
> 

Same for me.

Obviously running /sbin/installkernel is not reasonable for
UID != 0 (or if $FAKEROOTKEY is set), so I would suggest to
skip /sbin/installkernel and the default Lilo setup in
install.sh for this case.


Only a suggestion, of course.

Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk06A8oACgkQUTlbRTxpHjeuVwCeJjTgyjcIqvqrUTqxoGgAJngd
iwkAn2U/qiekItqItRBmpeEqk/dH0FKZ
=LgO3
-----END PGP SIGNATURE-----
