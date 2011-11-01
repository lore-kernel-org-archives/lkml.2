Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1KAHhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:37:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35395 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751539Ab1KAHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:37:06 -0400
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX18Cf2Fc/+0CL9v95EF1Vhu9SBozgdRVkhdd9UTEmY
	3bPua6bsJzHOYq
Message-ID: <4EAFA19E.5080208@gmx.net>
Date: Tue, 01 Nov 2011 08:37:02 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ulist: generic data structure to build unique lists
References: <1318238525-28879-1-git-send-email-sensille@gmx.net> <20111011163749.b0c27813.akpm@linux-foundation.org>
In-Reply-To: <20111011163749.b0c27813.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12.10.2011 01:37, Andrew Morton wrote:
> 
> Generally, I really do ask that you provide us a complete description
> of what this utility is supposed to do.  Once that is understood we can
> then start to determine why none of the existing container helpers were
> suitable, and were not capable of being modified to be suitable.

Thanks for your kind comments. I sent an updated version to the list
accordingly. Please let me know if the documentation is good enough
and shows the purpose clearly.

> 
> For example, from a quick squint at the code I'm wondering why
> flex_array was unsuitable.
> 

ulist is currently implemented as an array, but this is not the way
to go to scale to larger lists. I'd rather switch to using rbtrees
over a certain threshold and will do so as soon as we settle on
putting it in lib/ instead of burying it inside fs/btrfs.

- -Arne
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOr6GeAAoJEPa4OwE4JkZ9TOcP/ArwGeCv8sQejihSahoXPum8
3F5/QhvNpQMtl//3iQ6duuyCbSNyskGQ6xViYmIhYoH8Q9E+DOgQrSa4lSgsJxte
4ItbiobmTnCOWHqbUckkjp8toBleXC2iSjvtpt7DCfP/H1enAi3lE9FONB5A6RcP
ekGoNlp0LIFqLa0hk8qZ8JGetxuR1YWcunkrZRAze/cj4nGcegxiH9bLvEWgEShk
o0QT8RNF1BFtef4unWyxnND+IUbwfvVMU61cKANbXvKhUfG6QxDH62QfYyxQ/Unw
S2IXFZ41I/vgZIE4MKUABYFhigFkmBC3Mze7BGeF084SussazisHdA6UQsQi/TPP
+fU73XTmpFbpg4z2XWAyDkq96qIYijgkSLwelSMRBza8/A3fGnLcKZSCNH3LbjGu
aBjIi8A4VbasiBt/Hx1Vu2v9feX+S1tlmiODoLVp5bsvjD592bAfJK8QOf9RAFYK
0PMV2Fw6yplv6RFfZ32aJwtsryLN6iTOq1LXOz71KBVDaMuZXEur298WhrVCmcEN
270Kd3cBbF/JAoCODw97f/UPE9qWF1Vye+dTEjIWqb8bk8RBrzW5C6Wsxk9BRoU4
dONNMet9ykhHJIbchlYiOv3SMz04+yJJV74MmypefXj6tbxrdYm4gvebx28bC4jm
Ok/DXMFAdLm6wCicjKgI
=GHYG
-----END PGP SIGNATURE-----
