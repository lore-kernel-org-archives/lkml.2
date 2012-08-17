Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923Ab2HQIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:09:26 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:43201 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030897Ab2HQIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:09:11 -0400
Message-ID: <502DFC1D.20903@kernelconcepts.de>
Date: Fri, 17 Aug 2012 10:09:01 +0200
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: Let the FT5x06 driver build without debugfs
References: <87k3wy1ii3.fsf@xmission.com>
In-Reply-To: <87k3wy1ii3.fsf@xmission.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/17/2012 02:15 AM, Eric W. Biederman wrote:
> When testing to make certain my user namespace code works in
> various configurations I tripped over the tf5x06.c not building
> with debugfs disabled.

Sorry for that.

There already is a patch for this issue which I slightly prefer. You
can find it in the mail from Guenther Roeck:
   http://www.mail-archive.com/linux-input@vger.kernel.org/msg00646.html

Thanks,
        Simon


- -- 
       Simon Budig                        kernel concepts GmbH
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAt/B0ACgkQO2O/RXesiHCszgCeID9FyWmWea9eyktU38ikzPQP
V2gAoLfff/V9CtE9xpVmS2wIyyrC2d0J
=SSUc
-----END PGP SIGNATURE-----
