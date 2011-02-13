Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1BMLHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:07:39 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41850 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1BMLHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=LuTKVV4ExRwZ5Mpkcm4g8kRKGBH4PxwQZhZpxnDAtxmnrhzZalWaq5TudgCPjFeWMN
         6NHPHB1tQ73ZqQBfWGs6GSWpMyL/uCgj36HL7dyQ8a9ppEhi3/EcGwSTJDCSaCpvdCEU
         bd8PwXBRZoLxq8jtZ63iqdn/aeM1q0ZxLNOOs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
Date: Sun, 13 Feb 2011 12:07:33 +0100
Message-ID: <AANLkTikk_1ywKCMkRgRR20h3ApEhc3kdErMDBx9c9T2f@mail.gmail.com>
Subject: Re: 2.6.38-rc4-git5: Reported regressions from 2.6.37
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Nicolas Stransky <Nico@stransky.cx>, sgh@sgh.dk,
        John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 11:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.37,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved regressions from 2.6.37, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2011-02-12       39       20          18
>  2011-02-03       19       11           7
>
>
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=27382
> Subject         : ath5k phy0: gain calibration timeout
> Submitter       : Nicolas Stransky <Nico@stransky.cx>
> Date            : 2011-01-23 00:18 (21 days old)
>

As I looked into the BR #27382...
The patch by Nick Kossifidis from comment #32 (see [1] and [2]) fixed
the problem for two affected users.

As I have an ath5k wifi device (but I am not affected) on one of my
machines, I could test also.

Hey, Nick :-)
You promised to send a fix to linux-wireless ML (hope, I didn't oversee it).

Raphael, might be good to wait for the promised patch?

- Sedat -

[1] https://bugzilla.kernel.org/show_bug.cgi?id=27382#c32
[2] http://www.kernel.org/pub/linux/kernel/people/mickflemm/fastchanfix.patch
