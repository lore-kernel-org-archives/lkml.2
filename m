Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0K1PWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 10:22:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0K1PWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 10:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=raMq2882Rl/ZBgNnLQZtTv7lfp3CNFxbmhPygD6F/L090MIFZQ2drc71SJW5NAEU3s
         ZO/Zku87mZPNhjPSx9tcALDOS9gYoPikPapi9WoM1Ecwgi/D0GgJshqMh0rhuzKu6mb3
         FH1azlDcBhIFA1vOGjQK/BqEzHKsRJ4nkJitA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Anca Emanuel <anca.emanuel@gmail.com>
Subject: Re: 2.6.37-rc3-git4 bad desktop performance
Date: Sun, 28 Nov 2010 16:21:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
In-Reply-To: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011281621.59036.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 28 listopada 2010 o 13:21:24 Anca Emanuel wrote:
> Linus,
> 
> Last known good kernel: 2.6.37-rc3
> Driver: nouveau
> Test: play a HD movie.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=23912
for your bug report, please add your address to the CC list in there, thanks!

PS. Please, send config, dmesg, do bisection etc. will be useful...

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
