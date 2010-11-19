Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0KSRkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:40:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65341 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab0KSRkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:40:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qEBpkMEI/ILzUR8jtAx4cf/wPz+bRicFAkOP2MAyMVtO3hpFJHm0f4m8KS6SrG8iVQ
         Lgaaotf+FayeKInJhpdIqIopw+miQX7yntKIETWrpvfpn1QVqXW7VphB8dWeiJLXyWVr
         D7wFrENyDxGYDgvGls6SPUfTOjtaVM5Csz09k=
MIME-Version: 1.0
In-Reply-To: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
Date: Fri, 19 Nov 2010 18:40:41 +0100
Message-ID: <AANLkTik6Aq+kWzpmYckKkV5yVMFPt-J0E7OMM6Rd4ouO@mail.gmail.com>
Subject: Re: linux-next: Tree for November 19
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salve,

2010/11/19 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Changes since 20101118:

This probably should not be available on x86_64

  BLD FW  drivers/net/wan/wanxlfw.inc
/bin/sh: as68k: command not found
/home/test/linux-2.6/drivers/net/wan/wanxlfw.S:39:0: fatal error: when
writing output to : Broken pipe
compilation terminated.
make[4]: *** [drivers/net/wan/wanxlfw.inc] Error 127
make[3]: *** [drivers/net/wan] Error 2
make[2]: *** [drivers/net] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

Am I right?


-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!
