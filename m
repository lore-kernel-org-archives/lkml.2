Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1JYJdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:33:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50983 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1JYJdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:33:12 -0400
Message-ID: <4EA68248.7000002@zytor.com>
Date: Tue, 25 Oct 2011 11:32:56 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Kyle Moffett <kyle@moffetthome.net>, Greg KH <greg@kroah.com>,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, John Hawley <warthog9@kernel.org>
Subject: Re: kernel.org tarball/patch signature files
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com> <4EA41FB7.CB5369CF@users.sourceforge.net> <20111025014911.GC22764@kroah.com> <CAGZ=bqKvb96VvZ5a+VJWZXKdr553n8SW2=JOLZS1fGY5KE7iZg@mail.gmail.com>            <4EA672D9.106@zytor.com> <15483.1319534028@turing-police.cc.vt.edu>
In-Reply-To: <15483.1319534028@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/25/2011 11:13 AM, Valdis.Kletnieks@vt.edu wrote:
> 
> Wasn't there once a kernel hack called seccomp, that only allowed 
> read syscalls on stdin and writes on stdout and that was it? ;)
> 

It's still there (and there are a bunch of other ways to do this in
Linux).  The big thing is to wrapper this up and get people to use it.
 Even better would be to get this into gzip, bzip2 and xz so it
happens automatically!

	-hpa
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOpoIwAAoJEL2gYIVJO6zkzr4P/2NRkQuMXLtaVLLaxGo1CRx+
7PrNNbUqOMCWcLaMJeNQZPabgWzpaUUshtxkUsmDcKuiHzZcXGK8Pp7QmCGVssmR
zPCn/D2bN+JFkqKxAJyTy57OE35ccXGanGd3BtmNe5KQic06SsEZJ/EWFRuTZxDP
t+Ub08/Fq35D8/dw6ZQ3UdFzwGDQt/8Oxs+gVymuYro08Cezz7aL6bYllS+v5Y1m
2EQ9Nk9sBe9wKLLQJqvwTTXl9abhzlugFCcCsK41PZ0fW38s9728NgKru4sn8CmC
O7E3aClUJPEu/58h6WnAavaemEjHPhQn0KqShgn+amgyqRTMbX+uwq5RY49pLWZ2
eEVRHbGkLLHkfQYJuCjM09y5sRGp1HZC3CUPiZoEZTZXTeZ0Fl162v6utyo39dxT
1TJYsYpoYYrjtg5jFBNLh1uQ1ZeI46fOvhP84v9JbSmYBpo/Fb1yb5nj5YflIpUs
XVXVv9mu0Cuz60tuf0ceqAsvoiYaliM56bZjr65pscOPDzTP/qPtY4Q9UfEjeiAO
1N/l3gBJpOcHD3K5E1v3wcfD0PMeAu1W3WfW9Mj4KswPIz3EFQ6h1ja/urGC8GD3
pw19Uv33mDVHAlKFmZ5N2qIAmbmNaXejDmqvZxsvUyvSzqk+EmB33oYzPv+6n76p
IWHwm1SNbBjQI2AlEmmW
=P2oY
-----END PGP SIGNATURE-----
