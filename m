Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0KHMzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:55:04 -0500
Received: from sunsite.ms.mff.cuni.cz ([195.113.15.26]:57788 "EHLO
	sunsite.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KHMzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:55:02 -0500
X-Greylist: delayed 3638 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 07:55:00 EST
Date: Mon, 8 Nov 2010 12:53:53 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Paul Koning <paul_koning@dell.com>
Cc: Richard Guenther <richard.guenther@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101108115353.GC2583@sunsite.ms.mff.cuni.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org> <m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org> <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com> <877hgorrj1.fsf@basil.nowhere.org> <AANLkTi=tC01jshWAr_HyVs6-HKK-Puarb6cLpxZyg-Kr@mail.gmail.com> <E1D1023D-4F2D-4EF4-8E97-CC5685B57A19@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1D1023D-4F2D-4EF4-8E97-CC5685B57A19@dell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 06:47:59AM -0500, Paul Koning wrote:
> I don't know about 4.5, but I noticed that with 4.6 (trunk), testcasese
> like gcc.c-torture/compile/20000804-1.c optimize away the asm and all the
> operand generation except for -O0.

That's fine, the asm isn't volatile and the output is not used.

	Jakub
