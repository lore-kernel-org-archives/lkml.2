Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955Ab2JWW61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:58:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41947 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2JWW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:58:26 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Andi Kleen <ak@linux.intel.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
In-Reply-To: Your message of "Mon, 22 Oct 2012 08:36:33 -0700."
             <20121022153633.GK2095@tassilo.jf.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org> <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com> <20121022132733.GQ16230@one.firstfloor.org> <20121022133534.GR16230@one.firstfloor.org> <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
            <20121022153633.GK2095@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1351033000_2138P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2012 18:56:40 -0400
Message-ID: <79194.1351033000@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.508720AB.0007,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1351033000_2138P
Content-Type: text/plain; charset=us-ascii

On Mon, 22 Oct 2012 08:36:33 -0700, Andi Kleen said:

> Thinking about it more PowerPC has a 16GB page, so we probably
> need to move this to prot.

Gaak - is that a typo?  If not, what is the use case - allowing a small number of
pages to cover all memory, with big wins on TLB hit ratios?  I certainly can't see
it as a sane primitive for a virtual memory design that does paging/swapping?

--==_Exmh_1351033000_2138P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUIcgqAdmEQWDXROgAQKGzw//QTyQq0JUUKzodJC7HovRCqtPHWi2CuuX
9O57hcMs9vT3OkgwaVesgcQy39Ro2ImnPlLCNlJXaemCDfdpZglY/XkCo3L9bmVG
OULdsCRUzl1/0F/7oXqRbccuHk+G5ck0jc80uUxgZYFH6Das83R00VVGv4xVdy3h
nFOgNdEC4FemnMtnMqVACA5s2t7t8Pdn/jbM7z3atSfFGG/J6Pa9/+HvLQtag+rs
Xl+xF1wNfwDxUEixjoooO9fWRDMm2j7P/Ushbdzh/3+soV+Y2ZCzTvDMmH9uDRSx
/8sXkhk8fH4ZdWPkXacMUYCKIEcx9lp1bhNyElJmtrsB4Z+UEEL70jyfdZm5bkYD
3c6ZnrpLAX+oJWWD+mdGK/NqKUOu8JGOJ1/eoObH7Jj7dHeO6QDRld/I+whbD+YN
4jDMU3xgYi9Rs0qCdOyYSntzsn7wMgBXhd1zXX7FVP7ighvOpOQu7Iy9Nij26+22
I+jN/6Kt2fhD3uzWTT3+Ocj7JR/7ACXTM+lLZXCk0N88TQbAwDxehyZ0ayzKXqzV
GE0Ivdq0Mlfj9YoIn1eLiWr7yKT2kwkPJQoNrrJcJ/PumQWZxSv+eZy9bswtP39I
oTGESX5u+jtSYOOA2mqmI1dQBndgKsJyUJIqHInKM2ct07s6Tq2uzzYJ7DbuXNlN
yPNhVeQmm/s=
=HKHw
-----END PGP SIGNATURE-----

--==_Exmh_1351033000_2138P--

