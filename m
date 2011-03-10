Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1CJQ5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:57:19 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:50076 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1CJQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:57:18 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 11:57:18 EST
Message-ID: <4D79015B.4060707@afaics.de>
Date: Thu, 10 Mar 2011 17:50:35 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110303 Thunderbird/3.1.8
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Rio Karma not shown by blkid
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

How comes that the Rio Karma is not shown by blkid -c /dev/null, even
though the omfs module is loaded? Is this an issue of util-linux or of
the kernel?

Any helpful comment would be highly appreciated


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk15AVYACgkQUTlbRTxpHjfztgCaA4cSHl7SZOZk8a7Ljn+weG8J
jnYAn3/gJEOQuV9sNy/XJnlnL/re9ULY
=KWPz
-----END PGP SIGNATURE-----
