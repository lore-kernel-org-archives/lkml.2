Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2C1AAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:00:05 -0400
Received: from ozlabs.org ([203.10.76.45]:39381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2C1AAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:00:03 -0400
Date: Wed, 28 Mar 2012 10:59:56 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: linux-next: triage for March 18, 2012
Message-ID: <20120327235955.GA1394@thor.bakeyournoodle.com>
Mail-Followup-To: Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>
References: <20120318184105.GC2095@windriver.com>
 <20120318235114.GA30497@thor.bakeyournoodle.com>
 <20120319145125.GA12142@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20120319145125.GA12142@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Mar 19, 2012 at 10:51:25AM -0400, Paul Gortmaker wrote:

> Thanks for the updates.  I've added the am33 and h8300 info.  I don't
> know what to advise wrt. the frv platform...  there doesn't even appear
> to be an x86_64 cross that I can steal to try and reproduce it with.
> ( http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/ )

Look again now: http://kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

Yours Tony

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPclR7AAoJEEsCiJRY75GKqSUP/AiEwgF2xqM1G+e242/ckK3n
LxmxWqDgy6hg0WxSEM7wU8T2aoCEJAmIjJArgWccSxk2dnWmE0pnYzm5VdpkU7KX
YQgBb1U5xx/mgIKKGBP3HaEETSerFp5qZ/5YWKlpDWa01og9nZ/3pFpoDRjzWx5q
DDb7YqC7Ya/p3t43c7xgr/8PU4WCHbqadN67FpmSVsLbKJ3b4JAZAi8sfU86wBPH
VeQrVaj9HoHs8YCZccTWq+WZqlVugJNXQBpROXH2+cHy+RjbC2UPWoQLxhmAjfsQ
cE3ajNXKWD9KAJUSjlf/d97+1j1zrUbCHyqzVcimViqMhqwAL7veFoMy++cSN6ZM
W/i/y9fbbn6Rox/KNgB2MQ7rzLbz/1uRRtzW6oBM8Omkuty+OMpZRzdIq+KjbN+J
TtZB8A43mvJM6NJnLLQ6ENXVQsxqH6DtoXiLv4FKTGXuYVBHd2w/vq/1qHL59lw0
cnnISLFqxCRxRVgsNtKhLNFE0eGP4iNlrHJXmCC2JU5yINoy9iFk6Mbx+4iDCiIC
Ndx/iTkuQvsXehyJMu0CIDrd3iSL6Gr6qThoTAifr07PDHlYrz3l/8SMZp7Lgksy
fCt0t5nnZmb2xXHdVKX+l91TgacIBjXaX4Aqyesdi4pjCGgg5W+EHAbGLqYhZ2MJ
c/9LgnSQK9LXidGv0KCu
=rH7x
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
