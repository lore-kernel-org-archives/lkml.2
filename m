Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab1EMSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:34:13 -0400
Received: from bsmtp4.bon.at ([195.3.86.186]:38244 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750746Ab1EMSeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:34:11 -0400
X-Greylist: delayed 85155 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 14:34:11 EDT
Message-ID: <4DCD79A0.7000500@kdbg.org>
Date: Fri, 13 May 2011 20:34:08 +0200
From: Johannes Sixt <j6t@kdbg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Lutomirski <luto@mit.edu>,
        Christian Couder <christian.couder@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        git@vger.kernel.org, Shuang He <shuang.he@intel.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up
 hard right after logging in)
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com> <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com> <BANLkTi=dL+KyQ3Bm58_Uj4LP9WSpbzAfJA@mail.gmail.com> <BANLkTi=NdVUUZ=_bACzyeMGS3JWs0EMbWA@mail.gmail.com> <BANLkTimE2GkkhcFZtNrYZASWp0LDhUx=GQ@mail.gmail.com> <BANLkTinyzBnksHk_rt8K2pmg90q5WyZX3w@mail.gmail.com> <BANLkTinVT=9+-HhwXcyLBwrnhX9F9Qz3ww@mail.gmail.com>
In-Reply-To: <BANLkTinVT=9+-HhwXcyLBwrnhX9F9Qz3ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.05.2011 19:54, schrieb Linus Torvalds:
> For example, in your case, since you had certain requirements of
> support that simply didn't exist earlier, something like
> 
>    git bisect requires v2.6.38
> 
> would have been really useful - telling git bisect that any commit
> that cannot reach that required commit is not even worth testing.

You can already have this with

   git bisect good v2.6.38

It sounds a bit unintuitive, but with a slight mind-twist it can even be
regarded as correct in a mathematical sense: when the precondition is
false, the result is true. ;-)

-- Hannes
