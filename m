Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1AYAdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:33:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37186 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1AYAdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vtDUzc4rcB0Gw83XEKN/SVkOE6HIa3qGaKm9OUSS3Caan6ZdiL9DcEsvVxJUsaq8DY
         5JAC/IoEoUj1B9F8ke/HAG/DCylHYKiaHJaBHvcWKtf6+kAl2SmkQvu73ulrVXbOpWWG
         U8c+Eicql7EUXKWhPZCvFTtlxNq/n16DfYJy0=
MIME-Version: 1.0
In-Reply-To: <201101241659.03071.arnd@arndb.de>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
	<20110119182142.GA3620@elliptictech.com>
	<AANLkTimOzU328aHnB7+ERSq1ovPBSZgxNQsYRhLghH5L@mail.gmail.com>
	<201101241659.03071.arnd@arndb.de>
Date: Tue, 25 Jan 2011 11:33:07 +1100
Message-ID: <AANLkTik-3k1jQstYhxR7nv6+t2MMFei9ppthKBXF4AX8@mail.gmail.com>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might be looking in the wrong spot, but I can't see recent x.25
changes at http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git
If that is current make sure to pickup the previous x.25 bkl patches
submitted in december via net-next to avoid duplicate effort.

Andrew.

On Tue, Jan 25, 2011 at 2:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 23 January 2011, Andrew Hendry wrote:
>> Most the x.25 BKLs have patches accepted over the past few months.
>> There are 3 remaining in send, recieve and destroy that I haven't had time
>> to work through. If anyone wants to take a look at them I can help test, but
>> I wont have time until march to focus on them myself.
>
> I've given it a try on the weekend, see my bkl.git tree on kernel.org.
> I have patches for everything except IPX and UFS now, the latter was
> giving me a hard time but I think I'm getting close there. IPX
> should not be too hard.
>
>        ARnd
>
