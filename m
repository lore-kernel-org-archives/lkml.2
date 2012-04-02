Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2DBRVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:21:11 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:54722 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2DBRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:21:09 -0400
From: Romain Francoise <romain@orebokech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3 release
Organization: orebokech dot com
References: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
	<87r4wpx7lr.fsf@silenus.orebokech.com> <1332775433.22830.7.camel@ayu>
	<CA+55aFy_=-8LsSKiDhnVbOamiHJ3R2E5-USiHS4izQTbvCXCrA@mail.gmail.com>
X-Face: }9mYu,e_@+e!`Z-P5kVXa3\_b:hdJ"B)ww[&=b<2=awG:GOIM</2q'*t@MNa)R`k0h1KbUu "Ek%gXCQA(?k=Uf9}qgF_x#7/+Ql\R!NJ9[Z[ky\CTYI<H(kc][?[m%*rsf!OG11|f&H[VgX;),"!N JG6IziY\~""3M
Date: Mon, 02 Apr 2012 19:21:06 +0200
In-Reply-To: <CA+55aFy_=-8LsSKiDhnVbOamiHJ3R2E5-USiHS4izQTbvCXCrA@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 2 Apr 2012 09:46:21 -0700")
Message-ID: <877gxyt5h9.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> This issue should be fixed by commit c9651e70ad0a ("ASPM: Fix pcie
> devices with non-pcie children") in mainline, and it's in the stable
> queue too.

I can confirm that v3.4-rc1 boots fine on my machine. Thanks!
