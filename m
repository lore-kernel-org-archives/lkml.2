Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1FGKvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:51:17 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:47814 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1FGKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:51:15 -0400
Message-ID: <4DEE02A0.7030702@kernelconcepts.de>
Date: Tue, 07 Jun 2011 12:51:12 +0200
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Patch to add guarding parentheses to some macros in linux/input.h
References: <4DE6AD3B.4000600@kernelconcepts.de>
In-Reply-To: <4DE6AD3B.4000600@kernelconcepts.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/01/2011 11:20 PM, Simon Budig wrote:
> The attached patch adds parentheses to ensure correct operator precedence.

Seems this patch did not draw any attention to it. Is this because it is
somewhat pointless? Or is it too uncontroversial?  :-)

I'd appreciate any hints on how to proceed from here.

Thanks,
        Simon

- -- 
       Simon Budig                        kernel concepts GbR
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3uAqAACgkQO2O/RXesiHD8bwCfZz10ADGqx0yUbPJCSlmvNthL
JZsAn2Mc+gj1UQ5nSAWGonf46s6Xg/Uq
=Ug6H
-----END PGP SIGNATURE-----
