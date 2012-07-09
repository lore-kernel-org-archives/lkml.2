Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2GINxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:53:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47981 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753761Ab2GINxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:53:18 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+x8NcYm/ex8Kj6TFYYXXECAez+I1Ufe1acA2jSWQ
	YUboCiEE9RuZvv
Message-ID: <4FFAE24A.2070404@gmx.de>
Date: Mon, 09 Jul 2012 15:53:14 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120625 Thunderbird/13.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: "random PID" - worth to be considered (again)  ?
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reading [1] I'm wondering whether these would at least improve
OpenSSL's implementation of a RSA key generator (page 13 in [1]) ?

/me knows about the security-by-obscurity discussion like in [2],
however here I do not speak about guessing next PID, but about the
described entropy hole.

[1] https://factorable.net/weakkeys12.extended.pdf
[2] http://marc.info/?t=94754302700001&r=1&w=2

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

