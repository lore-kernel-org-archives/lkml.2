Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1BTAkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 19:40:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60425 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1BTAkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 19:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YLRifR886+TCkwGvclK9//uMr0Qw5n72y+oyoKOeegxs3+MBRsfH2QyiWRTNRUQKFg
         sJwmqfvb1Waj2M2SELxkZ5nQGGMTH5QGDttr4XC0mKczXTX3/HFtVB6MC0STHHZ73voc
         +bZc/HB7rcki6URpoz2CzoCtOJiRKUxeozUfM=
MIME-Version: 1.0
In-Reply-To: <8H3lez1sawF.A.vtH.IBxVNB@chimera>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
	<8H3lez1sawF.A.vtH.IBxVNB@chimera>
Date: Sat, 19 Feb 2011 19:40:06 -0500
Message-ID: <AANLkTinfAVyRupWqA7fJFO3TZe8X8w5UVtiFxzFTPYj5@mail.gmail.com>
Subject: Re: [Bug #27762] Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
From: John Mesmon <jmesmon@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure when this was fixed, but
a5bbef0b2deb7b943f095181309ecc9e1fc91c0f works.

On Sat, Feb 12, 2011 at 6:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=27762
> Subject         : Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
> Submitter       : John Mesmon <jmesmon@gmail.com>
> Date            : 2011-01-29 03:47 (15 days old)
> First-Bad-Commit: http://git.kernel.org/linus/44834a67c0082e2cf74b16be91e49108b1432d65
>
>
>
