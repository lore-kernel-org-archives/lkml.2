Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab0I0T1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:27:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55373 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab0I0T0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UXaqBsvjaNXvoEwRV/Qy9xQAmXsvg6ORBz1EnEK55zjad5YMYY+g596m4RornqiVP3
         ThRRihseMdG+lOF2C2znVxfbyg91VyoPnIkqTRYHtPOlmeqNNgzfwuAijSONoTAA5g2D
         gShHos+xTLUZHxKkfbtD+KituP/upG1+QrEp0=
MIME-Version: 1.0
In-Reply-To: <201009272051.33882.pluto@agmk.net>
References: <201009272051.33882.pluto@agmk.net>
Date: Mon, 27 Sep 2010 21:26:53 +0200
Message-ID: <AANLkTinCL--ndP3bbATGU46V8VJLs5hOWC++jbsodBiB@mail.gmail.com>
Subject: Re: git bisect selects commit outside initial bisect range?
From: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

W dniu 27 wrze¶nia 2010 20:51 u¿ytkownik Pawe³ Sikora <pluto@agmk.net> napisa³:
> hi,
>
> i've noticed on kernel 2.6.35.y some weird screen blinking during
> e.g. <alt-tab> on kde4 with enabled accelerated desktop effects.
>
> i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
> and after few steps git-bisect jumps to commit before v2.6.34.
>
> [~/src/linux/linux-2.6]$ make kernelrelease
> 2.6.34-rc6-00551-g7a6cb0d
>
> [~/src/linux/linux-2.6]$ git bisect log
> git bisect start
> # good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
> git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
> # bad: [67a3e12b05e055c0415c556a315a3d3eb637e29e] Linux 2.6.35-rc1
> git bisect bad 67a3e12b05e055c0415c556a315a3d3eb637e29e
> # good: [f8965467f366fd18f01feafb5db10512d7b4422c] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
> git bisect good f8965467f366fd18f01feafb5db10512d7b4422c
> # bad: [d79df0b1eda0099a22cbcece01ce5e7d222450de] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
> git bisect bad d79df0b1eda0099a22cbcece01ce5e7d222450de
> # good: [ac3ee84c604502240122c47b52f0542ec8774f15] Merge branch 'dbg-early-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
> git bisect good ac3ee84c604502240122c47b52f0542ec8774f15
>
> is it normal that bisect selects next step outside initial range?

It seems to me that it could happen - there are many merges of many
branches of the code - some of them may have really old commits.

>
> BR,
> Pawel.
>
> ps).
> please CC me on reply.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Slawa!
N.P.S.
