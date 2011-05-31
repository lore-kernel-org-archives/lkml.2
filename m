Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1EaNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:41:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42345 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1EaNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:41:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Safford <safford@watson.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
In-Reply-To: Your message of "Tue, 31 May 2011 08:05:08 EDT."
             <1306843508.3181.94.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com> <20110518172552.6d482c7a.akpm@linux-foundation.org> <20110526060842.GA13933@localhost.ucw.cz> <4DDE80FE.7010005@schaufler-ca.com> <1306433514.24986.26.camel@localhost.localdomain> <20110526183849.GA4563@ucw.cz> <1306439347.3092.89.camel@localhost.localdomain> <20110526201725.GC15959@elf.ucw.cz> <1306518351.24986.102.camel@localhost.localdomain> <20110529065818.GA2122@elf.ucw.cz>
            <1306843508.3181.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306849210_2772P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 May 2011 09:40:10 -0400
Message-ID: <30374.1306849210@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DE4EFBF.0041,ss=1,fgs=0,
	ip=71.62.120.129,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306849210_2772P
Content-Type: text/plain; charset=us-ascii

On Tue, 31 May 2011 08:05:08 EDT, Mimi Zohar said:

> For files that you don't expect to change, such as ELF executables, you
> probably could use the immutable flag, but using a digital signature
> provides authenticity as well, which the immutable flag does not
> provide.

The problem with 'chattr +i' is that if an attacker gets root, they can 'chattr
-i' and start scribbling. I've never personally trusted it for anything more
than protecting against overexuberant root processes that forget to obey file
permissions (like the DHCP script that keeps insisting on removing all the IPv6
nameservers out of my /etc/resolv.conf even when it's mode 444). As you noted,
digitally signing the executables with a key not found on the system raises the
bar substantially..


--==_Exmh_1306849210_2772P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN5O+6cC3lWbTT17ARArq7AJ9cBCkQWS5EI4QYkILDJYaRY7anjwCcCspI
rEqXlf75gbDQVqXS+Tb4+XA=
=nocB
-----END PGP SIGNATURE-----

--==_Exmh_1306849210_2772P--

