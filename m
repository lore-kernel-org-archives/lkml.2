Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1JSULX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:11:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58830 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1JSULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:11:21 -0400
Message-ID: <3ede57fd7fb0eff1aebed4ed9cb08301.squirrel@www.firstfloor.org>
In-Reply-To: <1319054816.3034.50.camel@dabdike.int.hansenpartnership.com>
References: <20111013233818.GB26654@one.firstfloor.org>
    <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
    <20111016033514.GC26654@one.firstfloor.org>
    <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
    <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
    <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
    <20111019161537.GH15908@one.firstfloor.org>
    <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
    <20111019163351.GJ15908@one.firstfloor.org>
    <1319050557.3034.46.camel@dabdike.int.hansenpartnership.com>
    <20111019190517.GK15908@one.firstfloor.org>
    <1319054693.3034.49.camel@dabdike.int.hansenpartnership.com>
    <1319054816.3034.50.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 19 Oct 2011 22:11:17 +0200
Subject: Re: Please include const-sections into linux-next
From: "Andi Kleen" <andi@firstfloor.org>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2011-10-19 at 15:04 -0500, James Bottomley wrote:
>> this is probably something to do with writeable strings?
>
> Bingo!  If I add -fno-writeable-strings to the compiler directives, it
> works.

Cool thanks. I assume the resulting kernel works.

This means the pa compiler defaults to -fwritable-strings? Odd.

Are you handling that or should I add a patch to the tree?

-Andi


